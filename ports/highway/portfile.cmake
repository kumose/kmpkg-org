kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/highway
    REF "${VERSION}"
    SHA512 8b9f4fdc4fa60b6817417959853f5b55bf86aec9d35fc6664dda15179cc55e0a9940f3a46011a84b95263ba342dc47ca1cb93b04481ff4b63d724cce1815d7c6
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        contrib  HWY_ENABLE_CONTRIB
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DHWY_ENABLE_INSTALL=ON
        -DHWY_ENABLE_EXAMPLES=OFF
        -DHWY_ENABLE_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME hwy CONFIG_PATH lib/cmake/hwy)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/hwy/highway_export.h" "defined(HWY_SHARED_DEFINE)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
