if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO s-yata/marisa-trie
    REF v${VERSION}
    SHA512 60757e354e4f0ff47662930af5c32a762c5f348c60019abb2d502c6c21ec220731edd9be8ea36e3ec68df90a6584eb311fe1e3d4258b3392609a87b0ef427121
    HEAD_REF master
    PATCHES
        enable-debug.patch
        fix-install.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS options
    FEATURES
        tools    ENABLE_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Marisa)
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

if ("tools" IN_LIST FEATURES)
    set(TOOL_NAMES marisa-benchmark marisa-build marisa-common-prefix-search marisa-dump marisa-lookup marisa-predictive-search marisa-reverse-lookup)
    kmpkg_copy_tools(TOOL_NAMES ${TOOL_NAMES} AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/bin" "${CURRENT_PACKAGES_DIR}/bin")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.md")
