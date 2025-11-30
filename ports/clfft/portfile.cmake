kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO clMathLibraries/clFFT
    REF v2.12.2
    SHA512 19e9a4e06f76ae7c7808d1188677d5553c43598886a75328b7801ab2ca68e35206839a58fe2f958a44a6f7c83284dc9461cd0e21c37d1042bf82e24aad066be8
    HEAD_REF master
    PATCHES
        tweak-install.patch
        fix-build.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/src"
    OPTIONS
        -DCMAKE_CXX_STANDARD=11 # 17 removes std::unary_function
        -DBUILD_LOADLIBRARIES=OFF
        -DBUILD_EXAMPLES=OFF
        -DSUFFIX_LIB=
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_cmake_config_fixup(CONFIG_PATH CMake)
else()
    kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/clFFT)
endif()

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
