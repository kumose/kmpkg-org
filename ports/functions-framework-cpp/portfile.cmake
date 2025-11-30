# TODO(coryan) - fix support for DLLs
kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GoogleCloudPlatform/functions-framework-cpp
    REF "v${VERSION}"
    SHA512 3832e205a2505152ed6955d7cf5630b2045133221ddd96e2bef62e66cad58cea326f32428e2f494bbe1a10f5d66453d09ae46e6b972a7ed13f211efbb79527a8
    HEAD_REF main
    PATCHES 
        fix-integral-include.patch
        fix-asio-error.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install(ADD_BIN_TO_PATH)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_cmake_config_fixup(PACKAGE_NAME functions_framework_cpp CONFIG_PATH lib/cmake/functions_framework_cpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(
    INSTALL "${SOURCE_PATH}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright)

kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()
