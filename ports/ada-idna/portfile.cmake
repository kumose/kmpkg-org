kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ada-url/idna
    REF "${VERSION}"
    SHA512 e9887102e10b5963518ef4dc62b2538b941201e099eb80ee1c3a6742a370a7bbf600005363f665ffdc438b09ced9a30158b33c93032fc7d491ea54f158190db6
    HEAD_REF main
    PATCHES
        install.patch
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        simdutf         ADA_USE_SIMDUTF
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DADA_IDNA_BENCHMARKS=OFF
        -DBUILD_TESTING=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-ada-idna)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(
    COMMENT "ada-idna is dual licensed under Apache-2.0 and MIT"
    FILE_LIST
       "${SOURCE_PATH}/LICENSE-APACHE"
       "${SOURCE_PATH}/LICENSE-MIT"
)
