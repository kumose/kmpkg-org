kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO leethomason/tinyxml2
    REF "${VERSION}"
    SHA512 8a6ddd48c96bc4287437d5b5ca62c131c4416c57310b664c9088ca9c1ac9f4d43d16c1bad03f82dc5588d9486752f510d631609a3930f1d4243f12184ad1c5f9
    HEAD_REF master
    PATCHES
        0001-fix-do-not-force-export-the-symbols-when-building-st.patch
        0002-fix-check-for-TINYXML2_EXPORT-on-non-windows.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dtinyxml2_BUILD_TESTING=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/tinyxml2)
kmpkg_fixup_pkgconfig()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
