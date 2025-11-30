kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO OctoMap/octomap
    REF "v${VERSION}"
    SHA512 1cbee4f6b3569587986774447ad9ec4190f597310c4d6865ffa7cd8865ece2492e4a42fa369b633d9d7a9da782560d49deaa62a18601ea4f56396bdf1a6a5f52
    HEAD_REF devel
    PATCHES
      001-fix-exported-targets.patch
      fix-isnan.patch # Remove this patch in the next update
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_OCTOVIS_SUBPROJECT=OFF
        -DBUILD_DYNAMICETD3D_SUBPROJECT=OFF
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_copy_tools(
    TOOL_NAMES binvox2bt bt2vrml compare_octrees convert_octree edit_octree eval_octree_accuracy graph2tree log2graph
    AUTO_CLEAN)

kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(KMPKG_LIBRARY_LINKAGE STREQUAL static)
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/octomap")

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/octomap/LICENSE.txt")

kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()
