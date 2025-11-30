kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO randombit/botan
    REF "${VERSION}"
    SHA512 596f4c5c167d1a8d3e387b764fab95fc01827988df93da9cdf3c10d632c8e662d3f9a2121a43c79ab44534a45b7e63c0e1adef61c7666d7851b83f6065815788 
    HEAD_REF master
    PATCHES
        embed-debug-info.patch
        pkgconfig.patch
        verbose-install.patch
        configure-zlib.patch
        fix_android.patch
        libcxx-winpthread-fixes.patch
        fix-cmake-usage.patch
        0009-fix-regression-f2bf049-85491b3.patch # extract from PR 4255
)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/configure" DESTINATION "${SOURCE_PATH}")

if(KMPKG_TARGET_IS_MINGW)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_find_acquire_program(PYTHON3)

kmpkg_cmake_get_vars(cmake_vars_file)
include("${cmake_vars_file}")

set(pkgconfig_syntax "")
if(KMPKG_DETECTED_CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(pkgconfig_syntax "--msvc-syntax")
endif()

kmpkg_list(SET configure_arguments
    "--distribution-info=kmpkg ${TARGET_TRIPLET}"
    --disable-cc-tests
    --with-pkg-config
    --link-method=copy
    --with-debug-info
    --includedir=include
    --bindir=bin
    --libdir=lib
    --without-documentation
    "--with-external-includedir=${CURRENT_INSTALLED_DIR}/include"
)
kmpkg_list(SET pkgconfig_requires)

if("amalgamation" IN_LIST FEATURES)
    kmpkg_list(APPEND configure_arguments --amalgamation)
endif()

set(ZLIB_LIBS_RELEASE "")
set(ZLIB_LIBS_DEBUG "")
if("zlib" IN_LIST FEATURES)
    kmpkg_list(APPEND configure_arguments --with-zlib)
    kmpkg_list(APPEND pkgconfig_requires zlib)
    x_kmpkg_pkgconfig_get_modules(LIBS PREFIX "ZLIB" MODULES "zlib" ${pkgconfig_syntax})
endif()

if(KMPKG_TARGET_IS_EMSCRIPTEN)
    kmpkg_list(APPEND configure_arguments --cpu=wasm)
elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    kmpkg_list(APPEND configure_arguments --cpu=x86)
elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    kmpkg_list(APPEND configure_arguments --cpu=x86_64)
elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    kmpkg_list(APPEND configure_arguments --cpu=arm32)
elseif(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    kmpkg_list(APPEND configure_arguments --cpu=arm64)
else()
    message(FATAL_ERROR "Unsupported architecture")
endif()

# Allow disabling use of WinSock2 by setting BOTAN_USE_WINSOCK2=OFF in triplet
# for targeting older Windows versions with missing APIs.
if(KMPKG_TARGET_IS_WINDOWS AND DEFINED BOTAN_USE_WINSOCK2 AND NOT BOTAN_USE_WINSOCK2)
    kmpkg_list(APPEND configure_arguments --without-os-features=winsock2)
endif()

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    kmpkg_list(APPEND configure_arguments --os=windows)

    if(KMPKG_DETECTED_CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        kmpkg_list(APPEND configure_arguments --cc=msvc)
    endif()

    # When compiling with Clang, -mrdrand is required to enable the RDRAND intrinsics. Botan will
    # check for RDRAND at runtime before trying to use it, so we should be safe to specify this
    # without triggering illegal instruction faults on older CPUs.
    if(KMPKG_DETECTED_CMAKE_CXX_COMPILER MATCHES "clang-cl(\.exe)?$")
        kmpkg_list(APPEND configure_arguments "--extra-cxxflags=${KMPKG_DETECTED_CMAKE_CXX_FLAGS} -mrdrnd")
    else()
        # ...otherwise just forward the detected CXXFLAGS.
        kmpkg_list(APPEND configure_arguments "--extra-cxxflags=${KMPKG_DETECTED_CMAKE_CXX_FLAGS}")
    endif()

    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        kmpkg_list(APPEND configure_arguments --enable-shared-library --disable-static-library)
    else()
        kmpkg_list(APPEND configure_arguments --disable-shared-library --enable-static-library)
    endif()

    if(KMPKG_CRT_LINKAGE STREQUAL "dynamic")
        set(BOTAN_MSVC_RUNTIME MD)
    else()
        set(BOTAN_MSVC_RUNTIME MT)
    endif()

    kmpkg_install_nmake(
        SOURCE_PATH "${SOURCE_PATH}"
        PROJECT_NAME "Makefile"
        PREFER_JOM
        PRERUN_SHELL_RELEASE
            "${PYTHON3}" "${SOURCE_PATH}/configure.py"
            ${configure_arguments}
            "--prefix=${CURRENT_PACKAGES_DIR}"
            "--msvc-runtime=${BOTAN_MSVC_RUNTIME}"
            "--with-external-libdir=${CURRENT_INSTALLED_DIR}/lib"
        PRERUN_SHELL_DEBUG
            "${PYTHON3}" "${SOURCE_PATH}/configure.py"
            ${configure_arguments}
            "--prefix=${CURRENT_PACKAGES_DIR}/debug"
            "--msvc-runtime=${BOTAN_MSVC_RUNTIME}d"
            "--with-external-libdir=${CURRENT_INSTALLED_DIR}/debug/lib"
            --debug-mode
        OPTIONS
            "CXX=\"${KMPKG_DETECTED_CMAKE_CXX_COMPILER}\""
            "LINKER=\"${KMPKG_DETECTED_CMAKE_LINKER}\""
            "AR=\"${KMPKG_DETECTED_CMAKE_AR}\""
            "EXE_LINK_CMD=\"${KMPKG_DETECTED_CMAKE_LINKER}\" ${KMPKG_LINKER_FLAGS}"
        OPTIONS_RELEASE
            "ZLIB_LIBS=${ZLIB_LIBS_RELEASE}"
        OPTIONS_DEBUG
            "ZLIB_LIBS=${ZLIB_LIBS_DEBUG}"
    )
    kmpkg_copy_tools(TOOL_NAMES botan-cli AUTO_CLEAN)
    kmpkg_copy_pdbs()
else()
    if(KMPKG_TARGET_IS_ANDROID)
        kmpkg_list(APPEND configure_arguments --os=android)
    elseif(KMPKG_TARGET_IS_EMSCRIPTEN)
        kmpkg_list(APPEND configure_arguments --os=emscripten)
    elseif(KMPKG_TARGET_IS_MINGW)
        kmpkg_list(APPEND configure_arguments --os=mingw)
    endif()

    if(KMPKG_TARGET_IS_EMSCRIPTEN)
        kmpkg_list(APPEND configure_arguments --cc=emcc)
    elseif(KMPKG_DETECTED_CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        kmpkg_list(APPEND configure_arguments --cc=gcc)
    elseif(KMPKG_DETECTED_CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        kmpkg_list(APPEND configure_arguments --cc=clang)
    endif()
    # botan's install.py doesn't handle DESTDIR on windows host,
    # so we must avoid the standard '--prefix' and 'DESTDIR' install.
    kmpkg_configure_make(
        SOURCE_PATH "${SOURCE_PATH}"
        DISABLE_VERBOSE_FLAGS
        NO_ADDITIONAL_PATHS
        OPTIONS
            "${PYTHON3}" "${SOURCE_PATH}/configure.py"
            ${configure_arguments}
        OPTIONS_RELEASE
            "--prefix=${CURRENT_PACKAGES_DIR}"
            "--with-external-libdir=${CURRENT_INSTALLED_DIR}/lib"
        OPTIONS_DEBUG
            --debug-mode
            "--prefix=${CURRENT_PACKAGES_DIR}/debug"
            "--with-external-libdir=${CURRENT_INSTALLED_DIR}/debug/lib"
    )
    kmpkg_build_make(
        BUILD_TARGET install
        OPTIONS
            "ZLIB_LIBS_RELEASE=${ZLIB_LIBS_RELEASE}"
            "ZLIB_LIBS_DEBUG=${ZLIB_LIBS_DEBUG}"
    )
    if(NOT KMPKG_TARGET_IS_EMSCRIPTEN)
        kmpkg_copy_tools(TOOL_NAMES botan AUTO_CLEAN)
    endif()
endif()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/Botan-${VERSION}")

file(RENAME "${CURRENT_PACKAGES_DIR}/include/botan-3/botan" "${CURRENT_PACKAGES_DIR}/include/botan")

if(pkgconfig_requires)
    list(JOIN pkgconfig_requires ", " pkgconfig_requires)
    file(APPEND "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/botan-3.pc" "Requires.private: ${pkgconfig_requires}")
    if(NOT KMPKG_BUILD_TYPE)
        file(APPEND "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/botan-3.pc" "Requires.private: ${pkgconfig_requires}")
    endif()
endif()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/include/botan-3"
)

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/botan/build.h" "#define BOTAN_INSTALL_PREFIX R\"(${CURRENT_PACKAGES_DIR})\"" "")
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/botan/build.h" "#define BOTAN_INSTALL_LIB_DIR R\"(${CURRENT_PACKAGES_DIR}\\lib)\"" "" IGNORE_UNCHANGED)
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/botan/build.h" "#define BOTAN_INSTALL_LIB_DIR R\"(${CURRENT_PACKAGES_DIR}/lib)\"" "" IGNORE_UNCHANGED)
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/botan/build.h" "--prefix=${CURRENT_PACKAGES_DIR}" "")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/license.txt")
