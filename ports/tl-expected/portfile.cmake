kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO TartanLlama/expected
    REF "v${VERSION}"
    SHA512 764e11097fe6ff18499e0941288fbd1cac91fe68009e077ef803742d48dd38efa8cc57cd6207e7d384f577a11bcb9bff43d3d853ade20340af36fccaaa5d47ed
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DEXPECTED_BUILD_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/tl-expected)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/cmake")

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
