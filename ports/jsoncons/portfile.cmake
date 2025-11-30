# header-only library
kmpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO danielaparker/jsoncons
    REF v${VERSION}
    SHA512 01b6df6354b3f6f29dcc341b74d94f6a45846546e67adf34cff3bd1befcf436390fa246faf5da4153f6ce3a5c5b3ec8c160e5bc9a0e1a7dc2b092a3e3f0fd69d
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DJSONCONS_BUILD_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "share/cmake/${PORT}")
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
