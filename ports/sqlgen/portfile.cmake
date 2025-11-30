kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO getml/sqlgen
    REF "v${VERSION}"
    SHA512 41a6dd9f510f9ccf7869d9caa26a1884ab3fddeeff2c5cb5129773cb7d7f52d7b8e9192c9a8277dec7f57eda812e40b300e905c065d3e4ddb7871b8fb5e397af 
    HEAD_REF main
)

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" SQLGEN_BUILD_SHARED)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        duckdb              SQLGEN_DUCKDB
        mariadb             SQLGEN_MYSQL
        postgres            SQLGEN_POSTGRES
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSQLGEN_BUILD_TESTS=OFF
        -DSQLGEN_SQLITE3=ON
        -DSQLGEN_BUILD_SHARED=${SQLGEN_BUILD_SHARED}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(
    CONFIG_PATH "lib/cmake/${PORT}"
)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)
