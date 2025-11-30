kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO minio/minio-cpp
    REF "v${VERSION}"
    SHA512 c0748e757513aea394f76a0286294e668421096bfa64892d66aef69d611bcbda7c4ccf9d4df2502a9a92206b613c7d27011f4c9948e25b286feff8b64c952b1e
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME miniocpp CONFIG_PATH "lib/cmake/miniocpp")

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
