if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MediaArea/ZenLib
    REF "v${VERSION}"
    SHA512 4232eb6e73e9b380f6fe2ce3cfeb9fe343936362a35ca8d088c783dc6277332df762d689efe023e3f1418c2e6d2629e0b82ac93df9cce3ae0ab346c2ed1911f1
    HEAD_REF master
)

kmpkg_find_acquire_program(PKGCONFIG)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Project/CMake"
    OPTIONS
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
        -DCMAKE_REQUIRE_FIND_PACKAGE_PkgConfig=1
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME zenlib)
kmpkg_fixup_pkgconfig()
if(NOT KMPKG_BUILD_TYPE AND KMPKG_TARGET_IS_WINDOWS)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libzen.pc" " -lzen" " -lzend")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.txt")
