kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kguiaddons
    REF v5.98.0
    SHA512 957edb3a4c78dcc52ae96f4565b617413b9dcd10e2681df0a945042c1d2ae87b8327567ad58f78c665e2e38351d6cc33129cf1ad30497912ccfa281c870e1607
    HEAD_REF master
    PATCHES
        fix_cmake.patch # https://github.com/microsoft/kmpkg/issues/17607#issuecomment-831518812
        0001-Add-misisng-find_dependency-s-for-static-builds.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        wayland WITH_WAYLAND
        x11     WITH_X11
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DQtWaylandScanner_EXECUTABLE=${CURRENT_INSTALLED_DIR}/tools/qt5-wayland/bin/qtwaylandscanner
        -DBUNDLE_INSTALL_DIR=bin
        ${FEATURE_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        BUNDLE_INSTALL_DIR
        QtWaylandScanner_EXECUTABLE
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5GuiAddons CONFIG_PATH lib/cmake/KF5GuiAddons)
kmpkg_copy_pdbs()

kmpkg_copy_tools(
    TOOL_NAMES kde-geo-uri-handler
    AUTO_CLEAN
)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

