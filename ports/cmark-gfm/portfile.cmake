string(REGEX REPLACE "^([0-9]+\\.[0-9]+\\.[0-9]+)\\.([0-9]+)$" "\\1.gfm.\\2" GFM_VERSION "${VERSION}")

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO github/cmark-gfm
    REF ${GFM_VERSION}
    SHA512 435298fcf782dfc5b64c578ac839759b9d5cd0c08eb90d6702f26278062a0f4887c65c18e89e2c9f6be23f10dd835c769a7e0f8c934be068b6754dcca30cdd7c
    HEAD_REF master
    PATCHES
        add-feature-tools.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" CMARK_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" CMARK_SHARED)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools BUILD_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMARK_TESTS=OFF
        -DCMARK_SHARED=${CMARK_SHARED}
        -DCMARK_STATIC=${CMARK_STATIC}
        ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DBUILD_TOOLS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake)
kmpkg_cmake_config_fixup(PACKAGE_NAME cmark-gfm-extensions CONFIG_PATH lib/cmake-gfm-extensions)
kmpkg_fixup_pkgconfig()

if ("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES cmark-gfm AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
