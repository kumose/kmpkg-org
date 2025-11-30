set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO timsort/cpp-TimSort
    REF "v${VERSION}"
    SHA512 79a7640d9aef8c5347d4916efaf9dd70ceb4b72417b29a313a567a8d86786886dc44c79eff8f47092cd7c782c54ea82d2d33237360e3049aa2d4781441c31dbe
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/gfx PACKAGE_NAME gfx-timsort)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
