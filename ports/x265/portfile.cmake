kmpkg_from_bitbucket(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO multicoreware/x265_git
    REF "${VERSION}"
    SHA512 4b7d71f22f0a7f12ff93f9a01e361df2b80532cd8dac01b5465e63b5d8182f1a05c0289ad95f3aa972c963aa6cd90cb3d594f8b9a96f556a006cf7e1bdd9edda
    HEAD_REF master
    PATCHES
        disable-install-pdb.patch
        version.patch
        linkage.diff
        pkgconfig.diff
        pthread.diff
        compiler-target.diff
        neon.diff
        fix-cmake-4.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS OPTIONS
    FEATURES
        tool   ENABLE_CLI
)

if(KMPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    kmpkg_find_acquire_program(NASM)
    list(APPEND OPTIONS "-DNASM_EXECUTABLE=${NASM}")
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static" AND NOT KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_OSX)
        # x265 doesn't create sufficient PIC for asm, breaking usage
        # in shared libs, e.g. the libheif gdk pixbuf plugin.
        # Users can override this in custom triplets.
        list(APPEND OPTIONS "-DENABLE_ASSEMBLY=OFF")
    endif()
elseif(KMPKG_TARGET_IS_WINDOWS)
    list(APPEND OPTIONS "-DENABLE_ASSEMBLY=OFF")
endif()

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" ENABLE_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/source"
    OPTIONS
        ${OPTIONS}
        -DENABLE_SHARED=${ENABLE_SHARED}
        -DENABLE_PIC=ON
        -DENABLE_LIBNUMA=OFF
        "-DVERSION=${VERSION}"
    OPTIONS_DEBUG
        -DENABLE_CLI=OFF
    MAYBE_UNUSED_VARIABLES
        ENABLE_LIBNUMA
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

if("tool" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES x265 AUTO_CLEAN)
endif()

if(KMPKG_TARGET_IS_WINDOWS AND KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/x265.h" "#ifdef X265_API_IMPORTS" "#if 1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
