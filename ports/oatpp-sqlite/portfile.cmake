set(OATPP_VERSION "1.3.0")

kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oatpp/oatpp-sqlite
    REF ${OATPP_VERSION}
    SHA512 8a208145ee10ed858767b4b56c220b6befd83e6858759128103ce679b889e6218a95ed6627af5098e4d26367be8add82de26e1f1f8ef581b1913b8386f9d56de
    HEAD_REF master
    PATCHES
        fix-usage.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DOATPP_BUILD_TESTS:BOOL=OFF"
        "-DOATPP_SQLITE_AMALGAMATION:BOOL=OFF"
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME oatpp-sqlite CONFIG_PATH lib/cmake/oatpp-sqlite-${OATPP_VERSION})
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
