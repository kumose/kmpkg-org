# header-only library

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xtensor-stack/xtensor-blas
    REF "${VERSION}"
    SHA512 d20d97e655de7e54415e174cfa8f99fe95f755af46e00160fa3c613b079003c113fbf137ec88991443cab30dac1ff1b28675183ade348221d00955f0fad31188
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS_RELEASE -DCXXBLAS_DEBUG=OFF
    OPTIONS_DEBUG -DCXXBLAS_DEBUG=ON
    OPTIONS
        -DXTENSOR_USE_FLENS_BLAS=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_BENCHMARK=OFF
        -DDOWNLOAD_GTEST=OFF
        -DDOWNLOAD_GBENCHMARK=OFF
)

kmpkg_cmake_install()

file(REMOVE "${CURRENT_PACKAGES_DIR}/include/xtensor-blas/xblas_config_cling.hpp")

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/xflens/cxxblas/netlib")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
