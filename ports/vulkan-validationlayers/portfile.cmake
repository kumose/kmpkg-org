set(KMPKG_LIBRARY_LINKAGE dynamic)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/Vulkan-ValidationLayers
    REF "vulkan-sdk-${VERSION}"
    SHA512 453fb519e2b4e035e82f9e372e235e6870eff7e32938fc903a3ee35354f4a535393f9f45264518e8ff5113ce3d59450668253b8d9b833c6f0669b7a1373cb7cc
    HEAD_REF main
)

kmpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
kmpkg_add_to_path("${PYTHON3_DIR}")

kmpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBUILD_TESTS:BOOL=OFF
)
kmpkg_cmake_install()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")

set(KMPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
set(KMPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

set(layer_path "<kmpkg_installed>/bin")
if(NOT KMPKG_TARGET_IS_WINDOWS)
 set(layer_path "<kmpkg_installed>/share/vulkan/explicit_layer.d")
endif()
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" @ONLY)
