# header-only library
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dpilger26/NumCpp
    REF "Version_${VERSION}"
    SHA512 d0306fd8d329b92e8040e540a00187309986c50aa57030ed8a67e839c4f2b48322d28d938446c81362fd708c734b77015914b5913ea20acb722b2f67e72b37f8
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        boost NUMCPP_NO_USE_BOOST
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME NumCpp CONFIG_PATH share/NumCpp/cmake)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
