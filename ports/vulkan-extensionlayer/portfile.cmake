set(KMPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
set(KMPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/Vulkan-ExtensionLayer
    REF "vulkan-sdk-${VERSION}"
    SHA512 a58d52dfdb73624a739784bfcb5e775ba7318478d6844a09a3fbbf71d092e080664b3dbde2eba282c671286e2f925b3f70986a09d97784256b88de8cabb67d47
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS:BOOL=OFF
)
kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(KMPKG_TARGET_IS_ANDROID)
    set(KMPKG_POLICY_SKIP_USAGE_INSTALL_CHECK enabled)
else()
    file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
endif()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
