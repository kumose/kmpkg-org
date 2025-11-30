kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Taywee/args
    REF "${VERSION}"
    SHA512 78e8eacc7dae8678fc30cb4f180fadfe5754781cfea89351240d6bd2789e38bc2c4e6c2e57e6f2d678c19240426a2e3eb95a84f51f3536736ca2c4239ed5c691
    HEAD_REF master
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DARGS_BUILD_UNITTESTS=OFF
        -DARGS_BUILD_EXAMPLE=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
