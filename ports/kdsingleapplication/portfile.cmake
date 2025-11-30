kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDAB/KDSingleApplication
    REF "v${VERSION}"
    SHA512 12540e70014f04b20529d19bc41bf089580c8a82e407511979017020d3f1d96c60112b208d5abe1e6c4e90ed65d3b0ca9dc2f09f20c8b580c3b8a17ae9a84ae0
    HEAD_REF master
    PATCHES "fix-license-text.patch"
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" KDSingleApplication_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DKDSingleApplication_QT6=ON
        -DKDSingleApplication_STATIC=${KDSingleApplication_STATIC}
        -DKDSingleApplication_TESTS=OFF
        -DKDSingleApplication_EXAMPLES=OFF
        -DKDSingleApplication_DOCS=OFF
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME KDSingleApplication-qt6 CONFIG_PATH lib/cmake/KDSingleApplication-qt6)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(
    FILE_LIST
        "${SOURCE_PATH}/LICENSE.txt"
        "${SOURCE_PATH}/LICENSES/BSD-3-Clause.txt"
        "${SOURCE_PATH}/LICENSES/MIT.txt"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
