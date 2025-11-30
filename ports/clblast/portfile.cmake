kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CNugteren/CLBlast
    REF "${VERSION}"
    SHA512 cc93afd4e4860789c4fed8a82bb0019f039285060e74aa65a1916bf061aaa67cc6dc675000b28500046062f40570472abd9c34c210d130e10b8e5c591ceb8ad7
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DTUNERS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/CLBlast)
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
