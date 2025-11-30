set(KMPKG_BUILD_TYPE release) # Header-only library

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Tessil/array-hash
    REF v${VERSION}
    SHA512 7aee866aed1c21b838124fda6b11365fdbc04ec8fe7969fbb52c6a30fb81fa945130f85c596a06a9bd8b3235bb6f73444013c719de4fba2d7abc3be4549aa501
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "share/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
