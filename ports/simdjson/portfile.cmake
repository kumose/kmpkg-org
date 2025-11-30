kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO simdjson/simdjson
    REF "v${VERSION}"
    HEAD_REF master
    SHA512 3b6b13f8e969d1ad24f2656c78e80efeb1868fea1871362920e1aa0d0d59382ae2bf174b81329edce52a659a5a4583919629bab639aac52d2d853791886ed6a0
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        exceptions SIMDJSON_EXCEPTIONS
        threads    SIMDJSON_ENABLE_THREADS
    INVERTED_FEATURES
        deprecated SIMDJSON_DISABLE_DEPRECATED_API
        utf8-validation SIMDJSON_SKIPUTF8VALIDATION
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" SIMDJSON_BUILD_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSIMDJSON_JUST_LIBRARY=ON
        -DSIMDJSON_SANITIZE_UNDEFINED=OFF
        -DSIMDJSON_SANITIZE=OFF
        -DSIMDJSON_SANITIZE_THREADS=OFF
        -DSIMDJSON_BUILD_STATIC=${SIMDJSON_BUILD_STATIC}
        -DSIMDJSON_DEVELOPMENT_CHECKS=OFF
        -DSIMDJSON_VERBOSE_LOGGING=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" "${SOURCE_PATH}/LICENSE-MIT")
