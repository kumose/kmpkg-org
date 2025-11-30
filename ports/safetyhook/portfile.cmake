kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cursey/safetyhook
    REF "v${VERSION}"
    SHA512 59244cff42c99ec7ebe1c5cbf26a5e01b8f23a991b4dfb9a8e02555edf319d485075f0c2a80cee9d247e93075faf3a528010003f47f59dbbd89d2537ed5a54c0
    HEAD_REF main
)

kmpkg_find_acquire_program(GIT)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DGIT_EXECUTABLE=${GIT}"
        "-DSAFETYHOOK_FETCH_ZYDIS=OFF"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/safetyhook)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
