kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO randy408/libspng
    REF "v${VERSION}"
    SHA512 cd729653599ed97f80d19f3048c1b3bc2ac16f922b3465804b1913bc45d9fc8b28b56bc2121fda36e9d3dcdd12612cced5383313b722a5342b613f8781879f1a
    HEAD_REF master
    PATCHES
        fix-spngconfig-cmake.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" SPNG_BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" SPNG_BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSPNG_STATIC=${SPNG_BUILD_STATIC}
        -DSPNG_SHARED=${SPNG_BUILD_SHARED}
        -DBUILD_EXAMPLES=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/spng PACKAGE_NAME spng)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
