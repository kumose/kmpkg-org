kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ThePhD/itsy_bitsy
    REF d5b6bf9509bb2dff6235452d427f0b1c349d5f8b
    SHA512 06489e46ad55a7fa55ddf88290509b157cf53518a8d9532d5a56e9907e5efaa298cb8946807e497461d322f62b4bad9b16864ef0def527edc8503f7a7884b8e1
    HEAD_REF main
    PATCHES fix-cmake-install.patch
)

set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    -DFETCHCONTENT_FULLY_DISCONNECTED=ON
    -DITSY_BITSY_SINGLE=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME itsy.bitsy CONFIG_PATH "lib/cmake/itsy.bitsy")

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
