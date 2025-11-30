kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/plasma-wayland-protocols
    REF "v${VERSION}"
    SHA512 3cb5ea1c5c69384181005520c9999b0f1548ec91f2894204ab9a103dd6d76621932f4d6c536664797ab2d24df4e1f182a353bd9be802565ec48dec657cc59276
    HEAD_REF master
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME PlasmaWaylandProtocols CONFIG_PATH lib/cmake/PlasmaWaylandProtocols)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

# Allow empty include directory
set(KMPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)