# volk is not prepared to be a DLL.
kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zeux/volk
    REF "vulkan-sdk-${VERSION}"
    SHA512 0be7705dfd643582fcd156972b69216e2f42bdf4cf42846a9ad21e5165cb38c0c1912d2786d4bfff8553c3b9b3664318e6efe9067ce1d73417539999434826cb
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DVOLK_INSTALL=ON
        -DVULKAN_HEADERS_INSTALL_DIR=${CURRENT_INSTALLED_DIR}
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/volk)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
