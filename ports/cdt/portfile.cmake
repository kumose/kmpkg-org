kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO artem-ogre/CDT
    REF "${VERSION}"
    SHA512 9b21553c6f377b257ef408d7f77e9b564175fdbe33dd5fdce6ddeb0aece258a5d77b00ad054d22dfa712952ba38a6717ef7b0a01b8950f97b073f6ebd81c3dd4
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "64-bit-index-type"     CDT_USE_64_BIT_INDEX_TYPE
        "as-compiled-library"   CDT_USE_AS_COMPILED_LIBRARY
)

if (NOT CDT_USE_AS_COMPILED_LIBRARY)
    set(KMPKG_BUILD_TYPE "release") # header-only
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/CDT"
    OPTIONS
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH cmake)

if (CDT_USE_AS_COMPILED_LIBRARY)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
