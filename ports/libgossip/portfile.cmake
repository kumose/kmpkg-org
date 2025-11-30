if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY) # DLL broken in 1.1.2.0
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO caomengxuan666/libgossip
    REF "v${VERSION}"
    SHA512 64320a74b1be5270bba2ea213c7a76900626d54afe4b6a0381dfdf0b2d5a64cab0e8e00234f3c75f232a6d1b4579931cbf3bc8b92503fccf7b815973ab2ed010
    HEAD_REF main
    PATCHES
        fix-dependencies.patch
        remove-export-headers.patch
        support-uwp.patch
)
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    -DBUILD_TESTS=OFF
    -DBUILD_EXAMPLES=OFF
    -DBUILD_PYTHON_BINDINGS=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libgossip)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
