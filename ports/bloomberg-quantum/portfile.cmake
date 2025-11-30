kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO bloomberg/quantum
    REF f4b872f99480bc7f2ab60620d99823e8f2d3b0d6
    SHA512 c41930c8bb0a1b70fdd4123ef349a0e8e892e0ecd52b412a171b1ce05386323a9ed2376a792ac12cd69f7d5a97a257bc08c2b85ce8a5f16b6f4e75740823b53b
    HEAD_REF master
    PATCHES rename-config-file-and-namespace.patch
)

set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS 
        -DQUANTUM_EXPORT_PKGCONFIG=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-${PORT} CONFIG_PATH "share/cmake/unofficial-${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
