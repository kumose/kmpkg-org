kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO saprykin/plibsys
    REF "${VERSION}"
    SHA512 ccc4dd0e54d69121542f4ddec319ec9fd2069866a93135acb87fe564c7bd067a218038dfaa4ddda4debcd897975c016165cbe3d41af6c2149d2b49fbe52f8fbb
    HEAD_REF master
    PATCHES
        fix_configuration.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" PLIBSYS_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DPLIBSYS_TESTS=OFF
        -DPLIBSYS_COVERAGE=OFF
        -DPLIBSYS_BUILD_DOC=OFF
        -DPLIBSYS_BUILD_STATIC=${PLIBSYS_STATIC}
        -DPLIBSYS_WRITE_PACKAGE=TRUE
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/plibsys)

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
