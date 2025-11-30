#header-only library
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/wil
    REF "v${VERSION}"
    SHA512 9691939bfa1229ad1890e72bea801df60ee46f307591aee816ed771d225ed62b4caaf5d2ecefcbf200a41ee68f53823ec43a97c3a2d1a632aa3fcf18b35e4996
    HEAD_REF master
)

# WIL is header-only, so we don't need to build it in both modes
set(KMPKG_BUILD_TYPE release)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DWIL_BUILD_TESTS=OFF
        -DWIL_BUILD_PACKAGING=ON
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/WIL)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

# Install natvis files
file(INSTALL "${SOURCE_PATH}/natvis/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/natvis")

# Install copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")