kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO SlickQuant/slick_queue
    REF "v${VERSION}"
    SHA512 52254f1e271e39ccaa9ca52bad7c53c261ee271803ed89e718798d93f9c78d8303eb3916f88933191595ed278b540d24afe351c5a55ee1f09cbdf09631c32dd3
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_SLICK_QUEUE_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(
    PACKAGE_NAME slick_queue
    CONFIG_PATH lib/cmake/slick_queue
)

# Header-only library - remove lib directory
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")

# Install license
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
