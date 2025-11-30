# Header-only library
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO beached/utf_range
    REF "v${VERSION}"
    SHA512 91ce2a335f5305f481d2bd7fd5954ae4f0ea66f32244cf3a0111ec4185080d90a9850dedbd38c077a66c46d99ca2045620702cf1e06683b6105651efbc6b5300
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DDAW_USE_PACKAGE_MANAGEMENT=ON
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

# remove empty lib and debug/lib directories (and duplicate files from debug/include)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
