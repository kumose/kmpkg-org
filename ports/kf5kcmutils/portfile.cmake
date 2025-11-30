kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kcmutils
    REF v5.98.0
    SHA512 959901d7ba447eff13e4c1341c5530fccecf42f7f5e4dc69bee669c9e22770f5af57ed2f08979aac5fd2e1015f2bbadf5d302d99e1e0031c20927d833e6a3cea
    HEAD_REF master
    PATCHES
        0001-Fix-missing-kcmutils_proxy_model-export-in-static-bu.patch   # https://invent.kde.org/frameworks/kcmutils/-/merge_requests/104
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_QMLDIR=qml
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5KCMUtils CONFIG_PATH lib/cmake/KF5KCMUtils)
kmpkg_copy_pdbs()

if(NOT KMPKG_TARGET_IS_WINDOWS)
    set(LIBEXEC_FOLDER "lib/libexec")
    set(LIBEXEC_SUBFOLDER "kf5/")
else()
    set(LIBEXEC_FOLDER "bin")
    set(LIBEXEC_SUBFOLDER "")
endif()

kmpkg_copy_tools(
    TOOL_NAMES kcmdesktopfilegenerator
    SEARCH_DIR "${CURRENT_PACKAGES_DIR}/${LIBEXEC_FOLDER}/${LIBEXEC_SUBFOLDER}"
    DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}/${LIBEXEC_SUBFOLDER}"
    AUTO_CLEAN
)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

