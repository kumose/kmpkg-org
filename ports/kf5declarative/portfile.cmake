kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kdeclarative
    REF v5.98.0
    SHA512 327eb517fc5fa47dcd5e1b70fff0a704528789e3cb6652db5269a8c41ba3ffeedc38b71f1e00403a5e0132029497a6dae90f4230d13ffdfeb0469b5ff91e2a71
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        "opengl" CMAKE_DISABLE_FIND_PACKAGE_EPOXY
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_QTPLUGINDIR=plugins
        -DBUNDLE_INSTALL_DIR=bin
        -DKDE_INSTALL_QMLDIR=qml
        ${FEATURE_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        CMAKE_DISABLE_FIND_PACKAGE_EPOXY
        BUNDLE_INSTALL_DIR
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5Declarative CONFIG_PATH lib/cmake/KF5Declarative)
kmpkg_copy_pdbs()

kmpkg_copy_tools(TOOL_NAMES kpackagelauncherqml AUTO_CLEAN)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

