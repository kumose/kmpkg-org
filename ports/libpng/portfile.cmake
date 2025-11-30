# Download the apng patch
set(LIBPNG_APNG_PATCH_PATH "")
if ("apng" IN_LIST FEATURES)
    if(KMPKG_HOST_IS_WINDOWS)
        # Get (g)awk and gzip installed
        kmpkg_acquire_msys(MSYS_ROOT PACKAGES gawk gzip)
        set(AWK_EXE_PATH "${MSYS_ROOT}/usr/bin")
        kmpkg_add_to_path("${AWK_EXE_PATH}")
    endif()

    set(LIBPNG_APNG_PATCH_NAME "libpng-${VERSION}-apng.patch")
    kmpkg_download_distfile(LIBPNG_APNG_PATCH_ARCHIVE
        URLS "https://downloads.sourceforge.net/project/libpng-apng/libpng16/${VERSION}/${LIBPNG_APNG_PATCH_NAME}.gz"
        FILENAME "${LIBPNG_APNG_PATCH_NAME}.gz"
        SHA512 746f74058d51d9f042479f296cdbd77b40ddb4cf1f8a94f6e1ca08b453f42bbda780689975f7607d54b8a0cd86f72e7a2804259b3afa1ddc1342e987bed5814d
    )
    set(LIBPNG_APNG_PATCH_PATH "${CURRENT_BUILDTREES_DIR}/src/${LIBPNG_APNG_PATCH_NAME}")
    if (NOT EXISTS "${LIBPNG_APNG_PATCH_PATH}")
        file(INSTALL "${LIBPNG_APNG_PATCH_ARCHIVE}" DESTINATION "${CURRENT_BUILDTREES_DIR}/src")
        kmpkg_execute_required_process(
            COMMAND gzip -d "${LIBPNG_APNG_PATCH_NAME}.gz"
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/src"
            ALLOW_IN_DOWNLOAD_MODE
            LOGNAME extract-patch.log
        )
    endif()
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pnggroup/libpng
    REF v${VERSION}
    SHA512 3b9b320b306388d0394404dbd6a978ba115743d913b4dd8d382b7ecf1f4e1979439e9829187058f52553f0aac0f73b274091a354c00286cdc699373b5c727fde
    HEAD_REF master
    PATCHES
        "${LIBPNG_APNG_PATCH_PATH}"
        cmake.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" PNG_SHARED)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" PNG_STATIC)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools PNG_TOOLS
    INVERTED_FEATURES
        tools SKIP_INSTALL_PROGRAMS
)

kmpkg_list(SET LIBPNG_HARDWARE_OPTIMIZATIONS_OPTION)
if(KMPKG_TARGET_IS_IOS)
    kmpkg_list(APPEND LIBPNG_HARDWARE_OPTIMIZATIONS_OPTION "-DPNG_HARDWARE_OPTIMIZATIONS=OFF")
endif()

kmpkg_list(SET LD_VERSION_SCRIPT_OPTION)
if(KMPKG_TARGET_IS_ANDROID)
    kmpkg_list(APPEND LD_VERSION_SCRIPT_OPTION "-Dld-version-script=OFF")
    if(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm")
        kmpkg_cmake_get_vars(cmake_vars_file)
        include("${cmake_vars_file}")
        if(KMPKG_DETECTED_CMAKE_ANDROID_ARM_NEON)
            kmpkg_list(APPEND LIBPNG_HARDWARE_OPTIMIZATIONS_OPTION "-DPNG_ARM_NEON=on")
        else()
            # for armeabi-v7a, check whether NEON is available
            kmpkg_list(APPEND LIBPNG_HARDWARE_OPTIMIZATIONS_OPTION "-DPNG_ARM_NEON=check")
        endif()
    endif()
endif()

if(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64" AND KMPKG_TARGET_IS_LINUX)
  kmpkg_list(APPEND LIBPNG_HARDWARE_OPTIMIZATIONS_OPTION "-DPNG_ARM_NEON=on")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${LIBPNG_HARDWARE_OPTIMIZATIONS_OPTION}
        ${LD_VERSION_SCRIPT_OPTION}
        -DPNG_STATIC=${PNG_STATIC}
        -DPNG_SHARED=${PNG_SHARED}
        -DPNG_FRAMEWORK=OFF
        -DPNG_TESTS=OFF
        -DSKIP_INSTALL_EXECUTABLES=ON
        -DSKIP_INSTALL_FILES=OFF
        ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
    MAYBE_UNUSED_VARIABLES
        PNG_ARM_NEON
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME png CONFIG_PATH lib/cmake/PNG)
kmpkg_cmake_config_fixup(CONFIG_PATH lib/libpng)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/png")

# unofficial legacy usage
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/libpng-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_fixup_pkgconfig()
if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libpng16.pc" "-lpng16" "-llibpng16d")
        file(INSTALL "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libpng16.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig" RENAME "libpng.pc")
    endif()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libpng16.pc" "-lpng16" "-llibpng16")
elseif(NOT KMPKG_BUILD_TYPE)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libpng16.pc" "-lpng16" "-lpng16d")
    file(INSTALL "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libpng16.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig" RENAME "libpng.pc")
endif()
file(INSTALL "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libpng16.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/pkgconfig" RENAME "libpng.pc")

kmpkg_copy_pdbs()

if(PNG_TOOLS)
    kmpkg_copy_tools(TOOL_NAMES "pngfix" "png-fix-itxt" AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
