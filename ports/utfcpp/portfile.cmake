set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nemtrif/utfcpp
    REF "v${VERSION}"
    SHA512 53c59f2e04fe5d36faf98a238b94f774834a34982d481a8170ee144f7f8c2d4ba249a732d90654922944c1075c578690c327091883398c533d604bf49f4a6ecf
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME utf8cpp CONFIG_PATH share/utf8cpp/cmake)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
