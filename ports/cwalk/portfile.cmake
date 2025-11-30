kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO likle/cwalk
    REF "v${VERSION}"
    SHA512 d29c83bb350a5477e450cdb86b1edf7232296aed67680345a84fee967ff414d5c997ac313e38620b51cda21398cc5d19c8130fe999ecd6b0161e81b3566f5516
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DENABLE_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cwalk)
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
