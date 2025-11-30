kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/knotifications
    REF v5.98.0
    SHA512 f7f492f6b5390f2cab2e946433165e058d6cb7f82e7ce2a4b931bd4b0e7f7d75fe0ffc431ae01a13a1c30475c4c7d8992343cce7d4b7eca0254b6e5ab5046237
    HEAD_REF master
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
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5Notifications CONFIG_PATH lib/cmake/KF5Notifications)
kmpkg_copy_pdbs()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

