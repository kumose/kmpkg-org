if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO flexible-collision-library/fcl
    REF ${VERSION}
    SHA512 95612476f4706fcd60812204ec7495a956c4e318cc6ace9526ac93dc765605ddf73b2d0d9ff9f4c9c739e43c5f8e24670113c86e02868a2949ab234c3bf82374
    HEAD_REF master
    PATCHES
        dont-lower-c++-std.diff
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" FCL_STATIC_LIBRARY)

if(KMPKG_TARGET_ARCHITECTURE STREQUAL "x64" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(FCL_USE_X64_SSE ON)
else()
    set(FCL_USE_X64_SSE OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=1
        -DCMAKE_REQUIRE_FIND_PACKAGE_Eigen3=1
        -DCMAKE_REQUIRE_FIND_PACKAGE_ccd=1
        -DCMAKE_REQUIRE_FIND_PACKAGE_octomap=1
        -DFCL_STATIC_LIBRARY=${FCL_STATIC_LIBRARY}
        -DFCL_BUILD_TESTS=OFF
        -DFCL_USE_X64_SSE=${FCL_USE_X64_SSE}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

if(EXISTS "${CURRENT_PACKAGES_DIR}/CMake")
    kmpkg_cmake_config_fixup(CONFIG_PATH CMake)
else()
    kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/fcl)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
