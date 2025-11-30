kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO RoaringBitmap/CRoaring
    REF "v${VERSION}"
    SHA512 680680fb05458911fd0ec0f0a506e804410227818ce2a272a3fb654b771da78dd5f76e933ae37124d11064a2f67d2d64c9a0cc2138fd5213c67285169474090d
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" ROARING_BUILD_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DROARING_BUILD_STATIC=${ROARING_BUILD_STATIC}
        -DENABLE_ROARING_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/roaring)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
