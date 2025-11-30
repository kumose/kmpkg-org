kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO webmproject/libvpx
    REF "v${VERSION}"
    SHA512 824fe8719e4115ec359ae0642f5e1cea051d458f09eb8c24d60858cf082f66e411215e23228173ab154044bafbdfbb2d93b589bb726f55b233939b91f928aae0
    HEAD_REF master
    PATCHES
        0003-add-uwp-v142-and-v143-support.patch
        0004-remove-library-suffixes.patch
        0005-dont-expect-gnu-diff.patch
)

if(CMAKE_HOST_WIN32)
    kmpkg_acquire_msys(MSYS_ROOT PACKAGES make perl)
    set(ENV{PATH} "${MSYS_ROOT}/usr/bin;$ENV{PATH}")
else()
    kmpkg_find_acquire_program(PERL)
    get_filename_component(PERL_EXE_PATH ${PERL} DIRECTORY)
    set(ENV{PATH} "${MSYS_ROOT}/usr/bin:$ENV{PATH}:${PERL_EXE_PATH}")
endif()

find_program(BASH NAME bash HINTS ${MSYS_ROOT}/usr/bin REQUIRED NO_CACHE)

if (KMPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    kmpkg_find_acquire_program(NASM)
    get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
    kmpkg_add_to_path(${NASM_EXE_PATH})
endif()

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)

    file(REMOVE_RECURSE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-tmp")

    if(KMPKG_CRT_LINKAGE STREQUAL static)
        set(LIBVPX_CRT_LINKAGE --enable-static-msvcrt)
        set(LIBVPX_CRT_SUFFIX mt)
    else()
        set(LIBVPX_CRT_SUFFIX md)
    endif()

    if(KMPKG_CMAKE_SYSTEM_NAME STREQUAL WindowsStore AND (KMPKG_PLATFORM_TOOLSET STREQUAL v142 OR KMPKG_PLATFORM_TOOLSET STREQUAL v143))
        set(LIBVPX_TARGET_OS "uwp")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL x86 OR KMPKG_TARGET_ARCHITECTURE STREQUAL arm)
        set(LIBVPX_TARGET_OS "win32")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL x64 OR KMPKG_TARGET_ARCHITECTURE STREQUAL arm64)
        set(LIBVPX_TARGET_OS "win64")
    endif()

    if(KMPKG_TARGET_ARCHITECTURE STREQUAL x86)
        set(LIBVPX_TARGET_ARCH "x86-${LIBVPX_TARGET_OS}")
        set(LIBVPX_ARCH_DIR "Win32")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL x64)
        set(LIBVPX_TARGET_ARCH "x86_64-${LIBVPX_TARGET_OS}")
        set(LIBVPX_ARCH_DIR "x64")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm64)
        set(LIBVPX_TARGET_ARCH "arm64-${LIBVPX_TARGET_OS}")
        set(LIBVPX_ARCH_DIR "ARM64")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm)
        set(LIBVPX_TARGET_ARCH "armv7-${LIBVPX_TARGET_OS}")
        set(LIBVPX_ARCH_DIR "ARM")
    endif()

    if(KMPKG_PLATFORM_TOOLSET STREQUAL v143)
        set(LIBVPX_TARGET_VS "vs17")
    elseif(KMPKG_PLATFORM_TOOLSET STREQUAL v142)
        set(LIBVPX_TARGET_VS "vs16")
    else()
        set(LIBVPX_TARGET_VS "vs15")
    endif()

    set(OPTIONS "--disable-examples --disable-tools --disable-docs --enable-pic")

    if("realtime" IN_LIST FEATURES)
        set(OPTIONS "${OPTIONS} --enable-realtime-only")
    endif()

    if("highbitdepth" IN_LIST FEATURES)
        set(OPTIONS "${OPTIONS} --enable-vp9-highbitdepth")
    endif()

    message(STATUS "Generating makefile")
    file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-tmp")
    kmpkg_execute_required_process(
        COMMAND
            ${BASH} --noprofile --norc
            "${SOURCE_PATH}/configure"
            --target=${LIBVPX_TARGET_ARCH}-${LIBVPX_TARGET_VS}
            ${LIBVPX_CRT_LINKAGE}
            ${OPTIONS}
            --as=nasm
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-tmp"
        LOGNAME configure-${TARGET_TRIPLET})

    message(STATUS "Generating MSBuild projects")
    kmpkg_execute_required_process(
        COMMAND
            ${BASH} --noprofile --norc -c "make dist"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-tmp"
        LOGNAME generate-${TARGET_TRIPLET})

    kmpkg_msbuild_install(
        SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-tmp"
        PROJECT_SUBPATH vpx.vcxproj
    )

    if (KMPKG_TARGET_ARCHITECTURE STREQUAL arm64)
        set(LIBVPX_INCLUDE_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/vpx-vp8-vp9-nopost-nodocs-${LIBVPX_TARGET_ARCH}${LIBVPX_CRT_SUFFIX}-${LIBVPX_TARGET_VS}-v${VERSION}/include/vpx")
    elseif (KMPKG_TARGET_ARCHITECTURE STREQUAL arm)
        set(LIBVPX_INCLUDE_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/vpx-vp8-vp9-nopost-nomt-nodocs-${LIBVPX_TARGET_ARCH}${LIBVPX_CRT_SUFFIX}-${LIBVPX_TARGET_VS}-v${VERSION}/include/vpx")
    else()
        set(LIBVPX_INCLUDE_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/vpx-vp8-vp9-nodocs-${LIBVPX_TARGET_ARCH}${LIBVPX_CRT_SUFFIX}-${LIBVPX_TARGET_VS}-v${VERSION}/include/vpx")
    endif()
    file(
        INSTALL
            "${LIBVPX_INCLUDE_DIR}"
        DESTINATION
            "${CURRENT_PACKAGES_DIR}/include"
        RENAME
            "vpx")
    if (NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "release")
        set(LIBVPX_PREFIX "${CURRENT_INSTALLED_DIR}")
        configure_file("${CMAKE_CURRENT_LIST_DIR}/vpx.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/vpx.pc" @ONLY)
    endif()

    if (NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "debug")
        set(LIBVPX_PREFIX "${CURRENT_INSTALLED_DIR}/debug")
        configure_file("${CMAKE_CURRENT_LIST_DIR}/vpx.pc.in" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/vpx.pc" @ONLY)
    endif()

else()

    set(OPTIONS "--disable-examples --disable-tools --disable-docs --disable-unit-tests --enable-pic")

    set(OPTIONS_DEBUG "--enable-debug-libs --enable-debug --prefix=${CURRENT_PACKAGES_DIR}/debug")
    set(OPTIONS_RELEASE "--prefix=${CURRENT_PACKAGES_DIR}")
    set(AS_NASM "--as=nasm")

    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        set(OPTIONS "${OPTIONS} --disable-static --enable-shared")
    else()
        set(OPTIONS "${OPTIONS} --enable-static --disable-shared")
    endif()

    if("realtime" IN_LIST FEATURES)
        set(OPTIONS "${OPTIONS} --enable-realtime-only")
    endif()

    if("highbitdepth" IN_LIST FEATURES)
        set(OPTIONS "${OPTIONS} --enable-vp9-highbitdepth")
    endif()

    if(KMPKG_TARGET_ARCHITECTURE STREQUAL x86)
        set(LIBVPX_TARGET_ARCH "x86")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL x64)
        set(LIBVPX_TARGET_ARCH "x86_64")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm)
        set(LIBVPX_TARGET_ARCH "armv7")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm64)
        set(LIBVPX_TARGET_ARCH "arm64")
    elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL riscv64)
        set(LIBVPX_TARGET_ARCH "riscv64")
    else()
        message(FATAL_ERROR "libvpx does not support architecture ${KMPKG_TARGET_ARCHITECTURE}")
    endif()

    kmpkg_cmake_get_vars(cmake_vars_file)
    include("${cmake_vars_file}")

    # Set environment variables for configure
    if(KMPKG_DETECTED_CMAKE_C_COMPILER MATCHES "([^\/]*-)gcc$")
        message(STATUS "Cross-building for ${TARGET_TRIPLET} with ${CMAKE_MATCH_1}")
        set(ENV{CROSS} ${CMAKE_MATCH_1})
        unset(AS_NASM)
    else()
        set(ENV{CC} ${KMPKG_DETECTED_CMAKE_C_COMPILER})
        set(ENV{CXX} ${KMPKG_DETECTED_CMAKE_CXX_COMPILER})
        set(ENV{AR} ${KMPKG_DETECTED_CMAKE_AR})
        set(ENV{LD} ${KMPKG_DETECTED_CMAKE_LINKER})
        set(ENV{RANLIB} ${KMPKG_DETECTED_CMAKE_RANLIB})
        set(ENV{STRIP} ${KMPKG_DETECTED_CMAKE_STRIP})
    endif()

    if(KMPKG_TARGET_IS_MINGW)
        if(LIBVPX_TARGET_ARCH STREQUAL "x86")
            set(LIBVPX_TARGET "x86-win32-gcc")
        else()
            set(LIBVPX_TARGET "x86_64-win64-gcc")
        endif()
    elseif(KMPKG_TARGET_IS_LINUX)
        # RISCV64 use target generic-gnu
        if(LIBVPX_TARGET_ARCH STREQUAL "riscv64")
            set(LIBVPX_TARGET "generic-gnu")
        else()
            set(LIBVPX_TARGET "${LIBVPX_TARGET_ARCH}-linux-gcc")
        endif()
    elseif(KMPKG_TARGET_IS_ANDROID)
        set(LIBVPX_TARGET "generic-gnu")
        # Settings
        if(KMPKG_TARGET_ARCHITECTURE STREQUAL x86)
            set(OPTIONS "${OPTIONS} --disable-sse4_1 --disable-avx --disable-avx2 --disable-avx512")
        elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL x64)
            set(OPTIONS "${OPTIONS} --disable-avx --disable-avx2 --disable-avx512")
        elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm)
            set(OPTIONS "${OPTIONS} --enable-thumb --disable-neon")
        elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm64)
            set(OPTIONS "${OPTIONS} --enable-thumb")
        endif()
        # Set environment variables for configure
        set(ENV{AS} ${KMPKG_DETECTED_CMAKE_C_COMPILER})
        set(ENV{LDFLAGS} "${LDFLAGS} --target=${KMPKG_DETECTED_CMAKE_C_COMPILER_TARGET}")
        # Set clang target
        set(OPTIONS "${OPTIONS} --extra-cflags=--target=${KMPKG_DETECTED_CMAKE_C_COMPILER_TARGET} --extra-cxxflags=--target=${KMPKG_DETECTED_CMAKE_CXX_COMPILER_TARGET}")
        # Unset nasm and let AS do its job
        unset(AS_NASM)
    elseif(KMPKG_TARGET_IS_OSX)
        if(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
            set(LIBVPX_TARGET "arm64-darwin20-gcc")
            if(DEFINED KMPKG_OSX_DEPLOYMENT_TARGET)
                set(MAC_OSX_MIN_VERSION_CFLAGS --extra-cflags=-mmacosx-version-min=${KMPKG_OSX_DEPLOYMENT_TARGET} --extra-cxxflags=-mmacosx-version-min=${KMPKG_OSX_DEPLOYMENT_TARGET})
            endif()
        else()
            set(LIBVPX_TARGET "${LIBVPX_TARGET_ARCH}-darwin17-gcc") # enable latest CPU instructions for best performance and less CPU usage on MacOS
        endif()
    elseif(KMPKG_TARGET_IS_IOS)
        if(KMPKG_TARGET_ARCHITECTURE STREQUAL arm)
            set(LIBVPX_TARGET "armv7-darwin-gcc")
        elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL arm64)
            set(LIBVPX_TARGET "arm64-darwin-gcc")
        else()
            message(FATAL_ERROR "libvpx does not support architecture ${KMPKG_TARGET_ARCHITECTURE} on iOS")
        endif()
    else()
        set(LIBVPX_TARGET "generic-gnu") # use default target
    endif()

    if (KMPKG_HOST_IS_BSD)
        set(MAKE_BINARY "gmake")
    else()
        set(MAKE_BINARY "make")
    endif()

    message(STATUS "Build info. Target: ${LIBVPX_TARGET}; Options: ${OPTIONS}")

    if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "release")
        message(STATUS "Configuring libvpx for Release")
        file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")
        kmpkg_execute_required_process(
        COMMAND
            ${BASH} --noprofile --norc
            "${SOURCE_PATH}/configure"
            --target=${LIBVPX_TARGET}
            ${OPTIONS}
            ${OPTIONS_RELEASE}
            ${MAC_OSX_MIN_VERSION_CFLAGS}
            ${AS_NASM}
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        LOGNAME configure-${TARGET_TRIPLET}-rel)

        message(STATUS "Building libvpx for Release")
        kmpkg_execute_required_process(
            COMMAND
                ${BASH} --noprofile --norc -c "${MAKE_BINARY} -j${KMPKG_CONCURRENCY}"
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
            LOGNAME build-${TARGET_TRIPLET}-rel
        )

        message(STATUS "Installing libvpx for Release")
        kmpkg_execute_required_process(
            COMMAND
                ${BASH} --noprofile --norc -c "${MAKE_BINARY} install"
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
            LOGNAME install-${TARGET_TRIPLET}-rel
        )
    endif()

    # --- --- ---

    if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "debug")
        message(STATUS "Configuring libvpx for Debug")
        file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")
        kmpkg_execute_required_process(
        COMMAND
            ${BASH} --noprofile --norc
            "${SOURCE_PATH}/configure"
            --target=${LIBVPX_TARGET}
            ${OPTIONS}
            ${OPTIONS_DEBUG}
            ${MAC_OSX_MIN_VERSION_CFLAGS}
            ${AS_NASM}
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
        LOGNAME configure-${TARGET_TRIPLET}-dbg)

        message(STATUS "Building libvpx for Debug")
        kmpkg_execute_required_process(
            COMMAND
                ${BASH} --noprofile --norc -c "${MAKE_BINARY} -j${KMPKG_CONCURRENCY}"
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
            LOGNAME build-${TARGET_TRIPLET}-dbg
        )

        message(STATUS "Installing libvpx for Debug")
        kmpkg_execute_required_process(
            COMMAND
                ${BASH} --noprofile --norc -c "${MAKE_BINARY} install"
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
            LOGNAME install-${TARGET_TRIPLET}-dbg
        )

        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
        file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/lib/libvpx_g.a")
    endif()
endif()

kmpkg_fixup_pkgconfig()

if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "debug")
    set(LIBVPX_CONFIG_DEBUG ON)
else()
    set(LIBVPX_CONFIG_DEBUG OFF)
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/unofficial-libvpx-config.cmake.in" "${CURRENT_PACKAGES_DIR}/share/unofficial-libvpx/unofficial-libvpx-config.cmake" @ONLY)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
