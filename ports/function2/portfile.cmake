kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Naios/function2
    REF "${VERSION}"
    SHA512 59ae559854eab40d65bfa24b41953333ce76e1e91af6232ff4f134514a044adf1d1fa4ffa0b33d49085b3f59c671c301aa1e69e4fbb3490c7099dc8ce34dac88
    HEAD_REF master
    PATCHES
        disable-testing.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE "${CURRENT_PACKAGES_DIR}/LICENSE.txt" "${CURRENT_PACKAGES_DIR}/Readme.md")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
