set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jarro2783/cxxopts
    REF "v${VERSION}"
    SHA512 a22da1436a263d51aad2f542c2099f5b4fd1b02674716ff26d2f575786dcec4e97400edebf5577de95f3ae48c7c99be7be17d7a3de3e01a9f3612667e1547908
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCXXOPTS_BUILD_EXAMPLES=OFF
        -DCXXOPTS_BUILD_TESTS=OFF
        -DCXXOPTS_ENABLE_WARNINGS=OFF
        -DCXXOPTS_CMAKE_DIR=share/cxxopts
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
