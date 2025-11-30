kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kpackage
    REF v5.98.0
    SHA512 2d82817825b3c5a284bee147abc1f8e9aff9f4730f7f149f95aef7270b7d41a7d6b8184e1f7c42c13c9ad26abbc63ffcd2e4eabef2f6ff734629d39808b5eeea
    HEAD_REF master
    PATCHES
        fix_duplicate_symbol.patch
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_KF5DocTools=ON
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5Package CONFIG_PATH lib/cmake/KF5Package)
kmpkg_copy_pdbs()

kmpkg_copy_tools(TOOL_NAMES kpackagetool5 AUTO_CLEAN)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

