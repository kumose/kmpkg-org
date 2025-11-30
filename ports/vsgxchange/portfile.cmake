kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vsg-dev/vsgXchange
    REF "v${VERSION}"
    SHA512 674a5ab3429009b99e465b5f063714b410d4cfc47e83117d0ea7304ca23f850ec135155b2cfb50055745e5e6a58d3eb3e1849f021c499c49e59558deac5b2526
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        assimp   vsgXchange_assimp
        assimp   KMPKG_LOCK_FIND_PACKAGE_assimp
        curl     vsgXchange_curl
        curl     KMPKG_LOCK_FIND_PACKAGE_CURL
        freetype vsgXchange_freetype
        freetype KMPKG_LOCK_FIND_PACKAGE_Freetype
        gdal     vsgXchange_GDAL
        gdal     KMPKG_LOCK_FIND_PACKAGE_GDAL
        openexr  vsgXchange_openexr
        openexr  KMPKG_LOCK_FIND_PACKAGE_OpenEXR
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DKMPKG_LOCK_FIND_PACKAGE_Doxygen=OFF
        -DKMPKG_LOCK_FIND_PACKAGE_osg2vsg=OFF
        -DKMPKG_LOCK_FIND_PACKAGE_draco=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/vsgXchange")

kmpkg_copy_tools(TOOL_NAMES vsgconv AUTO_CLEAN)
kmpkg_clean_executables_in_bin(FILE_NAMES vsgconvd)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
