if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mattgodbolt/seasocks
    REF "v${VERSION}"
    SHA512 18e596a09a825efd2421eee3b0d5ea389c0056c4b01c8b2078841d03863318e3f3ad59f6fd47fbe90409989c1fe05599f29b34a397427d282124e867371733ed
    HEAD_REF master
)

kmpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
kmpkg_add_to_path("${PYTHON3_DIR}")

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        zlib DEFLATE_SUPPORT
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUNITTESTS=OFF
        -DSEASOCKS_EXAMPLE_APP=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/Seasocks")

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/licenses")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
