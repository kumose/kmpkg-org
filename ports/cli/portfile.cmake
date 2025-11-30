kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO daniele77/cli
    REF "v${VERSION}"
    SHA512 c6d7421ca9c2c483f2c8adc4b44ab65da9eb78132784c53ff77ca63734c39619e590ec61814b100dfca6520af803cd0616ce8a54d4b4aa2312bf324f7d6a0ffc 
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cli)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
kmpkg_fixup_pkgconfig()
