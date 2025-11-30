kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ZXShady/enchantum
    REF ${VERSION}
    SHA512 7d44b63415c02c5ee02c4c3cf800e084cdb6dbf516a93f4cc37457b935fa5d563ffd29cca58db4ecee5afc007c3be638574d7fe9337b36354a0db9ecd4f24d2d
    HEAD_REF main
)

set(KMPKG_BUILD_TYPE release)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "cmake")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")