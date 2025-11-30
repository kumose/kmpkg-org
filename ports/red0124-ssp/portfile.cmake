kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO red0124/ssp
    REF "v${VERSION}"
    SHA512 9192c81adc3fce748abf2c16a0bbddc997ed766d098fa4d496c68957dad4d54be3b6ee5ca4ce0d8305e4e0e8c9dbe9c7c0cc7bfbeaf2f6475a9ac8f3c5f7af4a
    HEAD_REF master
    PATCHES
        no-fetchcontent.patch
)

set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME ssp CONFIG_PATH lib/cmake/ssp-${VERSION})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
