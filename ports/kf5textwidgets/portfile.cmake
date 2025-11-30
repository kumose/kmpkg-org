kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/ktextwidgets
    REF v5.98.0
    SHA512 d25167cf173daa55075ee0586b8db5c478fcc567d2b9466a7c833ffe8cfae21db936df8cbcfc06a82314568b4574b5826bc50bc24087a02bab56fb43fcdcd461
    HEAD_REF master
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_QTPLUGINDIR=plugins
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5TextWidgets CONFIG_PATH lib/cmake/KF5TextWidgets)
kmpkg_copy_pdbs()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

