kmpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}
kmpkg_download_distfile(ARCHIVE
    URLS "https://www.cairographics.org/releases/cairomm-${VERSION}.tar.xz"
    FILENAME "cairomm-${VERSION}.tar.xz"
    SHA512 d358a765136e244773b4a0fdcb2d9c81dd0b76f7a27c7108f94df9765f2d790f5f50b5645c09c292efce3e012528f85114d51916450c5fe6fa87d09f5a405d4c
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
        fix_include_path.patch
)

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dbuild-examples=false
        -Dmsvc14x-parallel-installable=false    # Use separate DLL and LIB filenames for Visual Studio 2017 and 2019
        -Dbuild-tests=false
)

kmpkg_install_meson()
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/cairommconfig.h" "# define CAIROMM_DLL 1" "# undef CAIROMM_DLL\n# define CAIROMM_STATIC_LIB 1")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
