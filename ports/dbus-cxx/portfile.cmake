kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dbus-cxx/dbus-cxx
    REF "${VERSION}"
    SHA512 ad6551d03d0c7d499e9f0c6d77584e39d361a1464017be3c40c237d4c43306ad0ffb49b52c06b89cd62ec7346ebcb29f3d166a31b245fd978159e337a08ebafb
    HEAD_REF master
    PATCHES
        create-cmakeconfig.patch    
        use-cmakeconfig.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "glib"          ENABLE_GLIB_SUPPORT
        "libuv"         ENABLE_UV_SUPPORT
        "qt6"           ENABLE_QT_SUPPORT
)

if (EXISTS "${CURRENT_INSTALLED_DIR}/lib/pkgconfig/libuv-static.pc")
    set(UV_STATIC ON)
else ()
    set(UV_STATIC OFF)
endif ()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_TESTING=OFF
        -DENABLE_CODE_COVERAGE_REPORT=OFF
        -DENABLE_EXAMPLES=OFF
        -DENABLE_TOOLS=OFF
        -DBUILD_SITE=OFF
        -DUV_STATIC=${UV_STATIC}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME "dbus-cxx" CONFIG_PATH "lib/cmake/dbus-cxx")
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
