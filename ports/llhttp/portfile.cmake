kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nodejs/llhttp
    REF refs/tags/release/v${VERSION}
    SHA512 7e6f5427b4b6d778ecefff892db78894ef4fd22a79e9c1f2c24d38d603d885755bdc8b0e8202b47c8bc209d3caf45a7293214617390a7a9c33bffbaab59fe5da
    PATCHES
        fix-usage.patch
)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" LLHTTP_BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" LLHTTP_BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_SHARED_LIBS=${LLHTTP_BUILD_SHARED}
        -DBUILD_STATIC_LIBS=${LLHTTP_BUILD_STATIC}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(
    CONFIG_PATH "/lib/cmake/${PORT}"
)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE-MIT")

kmpkg_fixup_pkgconfig()
