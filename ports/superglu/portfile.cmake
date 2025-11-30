kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO coin3d/superglu
    REF "v${VERSION}"
    SHA512 ff1edb95192b4593e99106bf5d7fe30aabd8e42b21a6a02b2dcb2431b1388d87e7c1186a2291047f8a10897e872329e8dd993e89414e4d88f2e9e95c6a74fd52
    HEAD_REF master
    PATCHES
        change-output-name.patch
)

kmpkg_find_acquire_program(PERL)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSUPERGLU_BUILD_SHARED_LIBS=OFF
        "-DPERL_EXECUTABLE=${PERL}"
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/superglu-${VERSION})
kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")