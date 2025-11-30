kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/cctz
    REF "v${VERSION}"
    SHA512 e3eba96482b7745b145ecfd9b3b96b09d9120bde952dfdb66d625e642a463b87c74205b1813e3c4bd9b408410bb26fb095d034ca56a4953005bf0c988ccc741e
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TOOLS=OFF
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
