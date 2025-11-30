if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MIT-SPARK/Spatial-Hash
    REF bf592f26d84beca96e3ddc295ee1cf5b7341dee5
    SHA512 c6e0c0475f2ca9bd9b21b227874202a12191496a446e44c493d6a181636912a342c56a8742cb5597a164f108bce74ec9534e224db4fa916c76930b232c82895f
    PATCHES
        compatible-kmpkg-cmake.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSPATIAL_HASH_BUILD_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(
    PACKAGE_NAME spatial_hash
    CONFIG_PATH lib/cmake/spatial_hash
)
kmpkg_copy_pdbs()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
