kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xsco/libdjinterop
    REF "${VERSION}"
    SHA512 772c0e674530e909a1882bc5afbe0e928a025589d932b67e5650a7fb91d8d9bd71f401e0c96d9486f0a5ce9a484647cbafce6213ba77b8efa620b9f5dd2085c0
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_DISABLE_FIND_PACKAGE_Boost=ON
    )
kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME djinterop CONFIG_PATH lib/cmake/DjInterop)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
