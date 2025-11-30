kmpkg_from_bitbucket(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO blaze-lib/blaze
    REF "v${VERSION}"
    SHA512 9786628159991f547902ceb44a159f0ba84d08be16ccc45bfb9aad3cfbf16eaede4ea43d2d4981d420a8a387a07721b113754f6038a6db2d9c7ed2ea967b5361
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        lapack   USE_LAPACK
        openmp   BLAZE_SHARED_MEMORY_PARALLELIZATION
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBLAZE_SMP_THREADS=OpenMP
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH share/blaze/cmake)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
