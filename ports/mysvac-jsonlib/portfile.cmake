kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Mysvac/cpp-jsonlib
    REF "v${VERSION}"
    SHA512 8bc16ec0085a88922e24595fa2311f0b8acf95a1e9eb33fa09ab871acb457d6aa0b2073b0f7f73adb14b26eadd5112f3427fc34d691027dd0d2fee43d187d401
    HEAD_REF main
)


kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
