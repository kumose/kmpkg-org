kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DrTimothyAldenDavis/GraphBLAS
    REF v${VERSION}
    SHA512 b43b3dc34e392a39de7112133e061ee5831017dde2f1cbfad7381abbbc0123740deb319b877ad891c5674caa0bdf0d5c7966780107dfad28eb89735af5bd8840
    HEAD_REF stable
    PATCHES
        crossbuild.diff
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIBS)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        openmp      GRAPHBLAS_USE_OPENMP
    INVERTED_FEATURES
        precompiled GRAPHBLAS_COMPACT
)

if(KMPKG_CROSSCOMPILING)
    list(APPEND FEATURE_OPTIONS "-DGRB_JITPACKAGE_EXECUTABLE=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/${PORT}/grb_jitpackage${KMPKG_HOST_EXECUTABLE_SUFFIX}")
endif()

# Prevent JIT cache from being created at ~/.SuiteSparse by default. Only used during build.
# see https://github.com/DrTimothyAldenDavis/SuiteSparse/blob/v7.8.1/GraphBLAS/cmake_modules/GraphBLAS_JIT_paths.cmake
set(ENV{GRAPHBLAS_CACHE_PATH} "${CURRENT_BUILDTREES_DIR}/cache")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
        -DSUITESPARSE_USE_CUDA=OFF
        -DSUITESPARSE_USE_STRICT=ON
        -DSUITESPARSE_USE_FORTRAN=OFF
        -DSUITESPARSE_DEMOS=OFF
        -DGRAPHBLAS_JIT_ENABLE_RELOCATE=ON
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/GraphBLAS" PACKAGE_NAME "graphblas")
kmpkg_fixup_pkgconfig()

if(NOT KMPKG_CROSSCOMPILING)
    kmpkg_copy_tools(AUTO_CLEAN TOOL_NAMES grb_jitpackage DESTINATION "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
