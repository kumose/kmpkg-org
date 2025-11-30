kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO team-charls/charls
    REF "${VERSION}"
    SHA512 4f1b587f008956ab6fb9d2473c37a7b1a842633113245be7f8bb29b8c64304a6d580a29fcfca97ba1ac75adedbaf89e29adc4ac9e4117e1af1aa5949dbd34df9
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCHARLS_BUILD_TESTS=OFF
        -DCHARLS_BUILD_SAMPLES=OFF
        -DCHARLS_BUILD_FUZZ_TEST=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/charls)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()
