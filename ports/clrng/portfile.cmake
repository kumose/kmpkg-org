kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO clMathLibraries/clRNG
    REF 4a16519ddf52ee0a5f0b7e6288b0803b9019c13b
    SHA512 28bda5d2a156e7394917f8c40bd1e8e7b52cf680abc0ef50c2650b1d546c0a1d0bd47ceeccce3cd7c79c90a15494c3d27829e153613a7d8e18267ce7262eeb6e
    HEAD_REF master
    PATCHES
        001-build-fixup.patch
)

file(REMOVE ${SOURCE_PATH}/src/FindOpenCL.cmake)

if(KMPKG_TARGET_ARCHITECTURE STREQUAL "x86" AND NOT KMPKG_CMAKE_SYSTEM_NAME)
    set(R123_SSE_FLAG [[-DCMAKE_C_FLAGS="/DR123_USE_SSE=0"]])
endif()

# We only have x64 and x86 as valid archs, as arm64 fails fast
string(COMPARE EQUAL "${KMPKG_TARGET_ARCHITECTURE}" "x64" BUILD64)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIBRARY)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/src"
    OPTIONS
        -DBUILD_SHARED_LIBRARY=${BUILD_SHARED_LIBRARY}
        -DBUILD64=${BUILD64}
        -DBUILD_TEST=OFF
        -DBUILD_CLIENT=OFF
        ${R123_SSE_FLAG}
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(
        REMOVE_RECURSE
            "${CURRENT_PACKAGES_DIR}/bin"
            "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/clRNG)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
