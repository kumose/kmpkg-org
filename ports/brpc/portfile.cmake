kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO apache/brpc
    REF "${VERSION}"
    SHA512 954be2562f598ca9a0939a96cb6f0af98dbbd9b3d191db613516239be63643ccfd1836eeb0510549f3526915af92e7c1b7f3cab4c55b0257cfc0a3c5eb4fb7dd
    HEAD_REF master
    PATCHES
        fix-build.patch
        fix-warnings.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_BRPC_TOOLS=OFF
        -DDOWNLOAD_GTEST=OFF
        -DWITH_THRIFT=ON
        -DWITH_GLOG=ON
        -DCMAKE_REQUIRE_FIND_PACKAGE_OpenSSL=ON
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-brpc CONFIG_PATH share/unofficial-brpc)
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/unofficial-brpc/unofficial-brpc-targets.cmake"
    "add_library(unofficial::brpc::brpc-"
    "add_library(#[[skip-usage-heuristics]] unofficial::brpc::brpc-"
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/butil/third_party/superfasthash")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

