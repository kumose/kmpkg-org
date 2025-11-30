if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nianticlabs/spz
    REF v${VERSION}
    SHA512 0e6bd1dd3f8625cc6730c0cc3a53f65a414a0504c463ca108ac972e4f09e949c49fd98d1033e27947080ead573695747c2a0b9c1a3d8aac7a39351abeb70bfc6
    HEAD_REF main
    PATCHES
        tools-improvements.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools   BUILD_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(
        TOOL_NAMES
            ply_to_spz
            spz_to_ply
            spz_info
        AUTO_CLEAN
    )
endif()

kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/spz")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
