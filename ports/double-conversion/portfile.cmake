kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/double-conversion
    REF "v${VERSION}"
    SHA512 60cab2fe623204cfa8737150e6ffcae091266180461dba377231e4fe8dccf712e74c643cd317b62266240ab82f1c0f820cf825038d627934d2dd0af1426f0cca
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
