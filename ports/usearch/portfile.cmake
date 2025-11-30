kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO unum-cloud/usearch
    REF "v${VERSION}"
    SHA512 d4d48c7477c490aa89cfc5eaf3f98f64c3fec1174d21e14dd5e6cbf08b344a5483e2a851e41a4f6e0bdc933b945b7e8f3d116cc84822b235e404bca20d7951ea
    HEAD_REF main
    PATCHES
        use-kmpkg-ports.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        fp16     USEARCH_USE_FP16LIB
        jemalloc USEARCH_USE_JEMALLOC
        simsimd  USEARCH_USE_SIMSIMD
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DUSEARCH_INSTALL=ON
        -DUSEARCH_BUILD_TEST_CPP=OFF
        -DUSEARCH_BUILD_BENCH_CPP=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/usearch)

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
