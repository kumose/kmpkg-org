kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xiph/flac
    REF "${VERSION}"
    SHA512 c8e119462205cfd8bbe22b0aff112625d3e51ca11de97e4de06a46fb43a0768d7ec9c245b299b09b7aa4d811c6fc7b57856eaa1c217e82cca9b3ad1c0e545cbe
    HEAD_REF master
    PATCHES
        android-cmake.diff
        fix-compile-options.patch
        fix-find-threads.patch
)

if("asm" IN_LIST FEATURES)
    kmpkg_find_acquire_program(NASM)
    get_filename_component(NASM_PATH "${NASM}" DIRECTORY)
    kmpkg_add_to_path("${NASM_PATH}")
endif()

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        asm WITH_ASM
        stack-protector WITH_STACK_PROTECTOR
        multithreading ENABLE_MULTITHREADING
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_PROGRAMS=OFF
        -DBUILD_EXAMPLES=OFF
        -DBUILD_DOCS=OFF
        -DBUILD_TESTING=OFF
        -DINSTALL_MANPAGES=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME FLAC CONFIG_PATH lib/cmake/FLAC)

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE "${CURRENT_PACKAGES_DIR}/share/LICENSE")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/FLAC/export.h"
        "#if defined(FLAC__NO_DLL)"
        "#if 0"
    )
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/FLAC++/export.h"
        "#if defined(FLAC__NO_DLL)"
        "#if 0"
    )
else()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/FLAC/export.h"
        "#if defined(FLAC__NO_DLL)"
        "#if 1"
    )
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/FLAC++/export.h"
        "#if defined(FLAC__NO_DLL)"
        "#if 1"
    )
endif()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/flac.pc" " -lm" "")

    if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/flac.pc")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/flac.pc" " -lm" "")
    endif()
endif()

kmpkg_fixup_pkgconfig()

# This license (BSD) is relevant only for library - if someone would want to install
# FLAC cmd line tools as well additional license (GPL) should be included
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.Xiph")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
