kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pantor/ruckig
    REF "v${VERSION}"
    SHA512 5399e1f0c61c1c4d96a8a910e4b934b629c6302fd18fd609c7a8bc76156bf0f3f5197ff9e83ac0fc443083e40cc7208d9a2f09070f4f8ab4511f4a6566981b5d
    HEAD_REF main
    PATCHES
        third_party.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        cloud BUILD_CLOUD_CLIENT
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_TESTS=OFF
        -DBUILD_EXAMPLES=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/ruckig")
kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")