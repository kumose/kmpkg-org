
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/SPIRV-Headers
    REF "vulkan-sdk-${VERSION}"
    SHA512 545526940e5b42a53143732d6d00b61ee544f8137507f86b32230fb5110cf2cc8f3fc71d0b167e614ab2dd5faa1c4915965627146d519832d73f23ee6a2aa4bb
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH "share/cmake/SPIRV-Headers")
kmpkg_fixup_pkgconfig()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
