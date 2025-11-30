kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ETLCPP/etl
    REF "${VERSION}"
    SHA512 a6863ee04cc247b1f81d747ef1711717387a3e9ecbce0de1d8391a7c97cce591d304121675ea1b46866a7e6c493572d1ff2131dc7e044d7b8bbfed6d64b9832d
    HEAD_REF master
)

# header-only
set(KMPKG_BUILD_TYPE "release")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH share/etl/cmake)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/etl/.vscode")
# remove templates used for generating headers
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/etl/generators")
file(GLOB_RECURSE PNG_FILES "${CURRENT_PACKAGES_DIR}/include/etl/*.png")
file(REMOVE ${PNG_FILES})

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
