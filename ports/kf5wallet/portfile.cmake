kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kwallet
    REF v5.98.0
    SHA512 8fae6e689f190f2f6d110ed4ccd45856d4202c9f4e08fd88851c120c1bfaa38d00f3571a08e036f60054740702084927f09809d68cde7c073f5ba1cd8124c2de
    HEAD_REF master
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_KWALLETD=OFF
        -DBUILD_KWALLET_QUERY=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KF5Wallet CONFIG_PATH lib/cmake/KF5Wallet)
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})

