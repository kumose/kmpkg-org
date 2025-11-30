#Get release from GitHub
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eclipse-ecal/fineftp-server
    REF "v${VERSION}"
    SHA512 10e6fe6724e1751cb72d212f5fc8053b9c715e79ab41b080beb35c3501377b9e8fd8137de0b30266709aa34432dfa4593026db1b04735f7c1a4dbde90763ea97
    HEAD_REF master
    PATCHES
        asio.patch
)

# Configure
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(
    PACKAGE_NAME fineftp
    CONFIG_PATH lib/cmake/fineftp
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
