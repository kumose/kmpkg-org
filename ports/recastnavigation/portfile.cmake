kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO recastnavigation/recastnavigation
    REF v${VERSION}
    SHA512 7567aaa78219cc490a6f76210fba1f130f0c17aeaa06432ab1207e0fd03404abe31042e8b03971aa0d04ad65d39469f13575fe0072fb920c38581d39568b70fb
    HEAD_REF master
    PATCHES
        fix-detail-mesh-edge-detection.patch #Upstream fix https://github.com/recastnavigation/recastnavigation/pull/657
)
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DRECASTNAVIGATION_DEMO=OFF
        -DRECASTNAVIGATION_TESTS=OFF
        -DRECASTNAVIGATION_EXAMPLES=OFF

)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/recastnavigation)

kmpkg_fixup_pkgconfig()

kmpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.txt")
