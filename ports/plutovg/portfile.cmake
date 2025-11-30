kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sammycage/plutovg
    REF "v${VERSION}"
    SHA512 ecffd41cf24fb7db39fc8916146dceeae7b2c0428f8e57fe3f0b353a1d23f45a04a33f0da24090c42ecab48b10a54648c0b4a677958423b4456cbbb3fd9e2b6b
    HEAD_REF main
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        font-face-cache        PLUTOVG_DISABLE_FONT_FACE_CACHE_LOAD
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DPLUTOVG_BUILD_EXAMPLES=OFF
        ${FEATURE_OPTIONS}
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/plutovg)
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/plutovg/plutovg.h" "defined(PLUTOVG_BUILD_STATIC)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
