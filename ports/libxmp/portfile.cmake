kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libxmp/libxmp
    REF libxmp-${VERSION}
    SHA512 5f7690e274f3857bd6889cd2ba637473f4a85359a6ef87c76313f87d0c725e3880ba6e428b542dbbf0c8a7725a87b5019289b3f19d2c5bb49527b380f1b4f7e4
    PATCHES
        fix-cmake-config-dir.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        depackers  LIBXMP_DISABLE_DEPACKERS
        prowizard  LIBXMP_DISABLE_PROWIZARD
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_STATIC=${BUILD_STATIC}
        -DBUILD_SHARED=${BUILD_SHARED}
        -DLIBXMP_DOCS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(
    PACKAGE_NAME "libxmp"
    CONFIG_PATH "lib/cmake/libxmp"
)

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/docs/COPYING.LIB")
