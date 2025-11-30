kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kiconthemes
    REF v5.98.0
    SHA512 822deb6e4469e69541e057b72f2ce27258f5cdb893f1cc8d37d900bb5aa4694706de051a905a939ac2f6fa474f69f4e05f24c87053699b205e6a58e18d56aaf1
    HEAD_REF master
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        designerplugin BUILD_DESIGNERPLUGIN
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_PLUGINDIR=plugins
        -DKDE_INSTALL_QTPLUGINDIR=plugins
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5IconThemes CONFIG_PATH lib/cmake/KF5IconThemes)
kmpkg_copy_pdbs()

kmpkg_copy_tools(
    TOOL_NAMES kiconfinder5
    AUTO_CLEAN
)

if(KMPKG_TARGET_IS_OSX)
    kmpkg_copy_tools(TOOL_NAMES ksvg2icns AUTO_CLEAN)
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

