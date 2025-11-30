kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/Vulkan-Tools
    REF "vulkan-sdk-${VERSION}"
    SHA512 ff505ba27556261103664b50ee88d26efdd040d7e0168ec0a37cdcebf421fbf75f73bdae55282c1e82b913491abd365a61edf95a5b917eb0b20abf6f60b89742
    HEAD_REF main
)

if(NOT KMPKG_TARGET_IS_ANDROID)
    set(KMPKG_BUILD_TYPE release) # only builds tools
endif()

kmpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBUILD_TESTS:BOOL=OFF
)
kmpkg_cmake_install()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")

set(tools vulkaninfo)
if(NOT KMPKG_TARGET_IS_ANDROID)
    list(APPEND tools vkcube vkcubepp)
endif()
kmpkg_copy_tools(TOOL_NAMES ${tools} AUTO_CLEAN)

set(KMPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

if(NOT KMPKG_TARGET_IS_ANDROID)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
endif()
