kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hyperrealm/libconfig
    REF "v${VERSION}"
    SHA512 1d9d7b21baf73259c09b503ca02942bdf847741378f8c3d7e138c9b4979c5304aae510595958fe1842b726778cedf2aaeb1844f8b209a61ccb24debea592bd0c
    HEAD_REF master
    PATCHES
        static-build.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTS=OFF
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libconfig)
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libconfig.h" "defined(LIBCONFIG_STATIC)" "1")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libconfig.h++" "defined(LIBCONFIGXX_STATIC)" "1")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
