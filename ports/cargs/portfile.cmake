kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO likle/cargs
    REF "v${VERSION}"
    SHA512 56877e330745369585b1b6ed274e8c898381439915048375a22a3fed077c1818b5d21356a33a77f516571d834a3fce7f78e509df63ce0f93b8276ac0a93df02a
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DENABLE_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cargs)
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
