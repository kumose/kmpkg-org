kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO simdutf/simdutf
    REF "v${VERSION}"
    SHA512 0d1d15f0030b002a6cb865b8876f252d9ad1657b7396248902f3adbe23023ac705a40c57e3f1895c3f66fbab6d490c69b545baecdd6ea7a085b0e5c694e38a42
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    "tools" SIMDUTF_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        -DSIMDUTF_TESTS=OFF
        -DSIMDUTF_BENCHMARKS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
kmpkg_fixup_pkgconfig()
if ("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES fastbase64 sutf AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE-APACHE")
