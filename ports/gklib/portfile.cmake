if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KarypisLab/GKlib
    REF 6e7951358fd896e2abed7887196b6871aac9f2f8
    SHA512 54ba87f2c47e025ada0fe6fe608d9d144df5cd13e97e71892dbba4d50cd96409add309937a540cdf8bd2632cbfbc0e22e080a32d114ba6037008c8676aa8d88d
    PATCHES
        build-fixes.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_INSTALL_INCLUDEDIR=include/GKlib
        -DGKLIB_BUILD_APPS=OFF
        -DSHARED=${SHARED}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/GKlib")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
