set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO osmcode/libosmium
    REF "v${VERSION}"
    SHA512 0d2b5e8e316d05c8e2d05b58d1c79136b1d78fffb116cb39987d007a4c68b325d8d7551e4c55b67e5c46927c92df720a0360c9abbc8784b9af9f86846297dae2
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON
        # for transitive dependencies via pkgconf 
        -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=1
        -DKMPKG_HOST_TRIPLET=${HOST_TRIPLET}
)
kmpkg_cmake_install()

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
