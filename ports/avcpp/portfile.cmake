if(KMPKG_TARGET_IS_WINDOWS)
    # avcpp doesn't export any symbols
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO h4tr3d/avcpp
    REF "v${VERSION}"
    SHA512 323fb8aa4a5cb2f069f387ff04fce083caaca6a5e9884977b42ebeac117d9bc61b62315cf55854a0dc6f54822501b9ffac0a2f071a52fec1090c8da801b9337a
    HEAD_REF master
    PATCHES
        0002-av_init_packet_deprecation.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" AVCPP_ENABLE_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" AVCPP_ENABLE_SHARED)

kmpkg_find_acquire_program(PKGCONFIG)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DAV_ENABLE_STATIC=${AVCPP_ENABLE_STATIC}"
        "-DAV_ENABLE_SHARED=${AVCPP_ENABLE_SHARED}"
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
        -DAV_BUILD_EXAMPLES=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(READ "${SOURCE_PATH}/LICENSE.md" LICENSE_MD)
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE-bsd.txt" "${SOURCE_PATH}/LICENSE-lgpl2.txt" COMMENT "${LICENSE_MD}")
