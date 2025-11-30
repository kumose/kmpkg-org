kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hoene/libmysofa
    REF "1f9c8df42dfd6765e390ed8840341f15e1ab997b"
    SHA512 67ce39d78981dc95cf190b1be4addceec4ecc7c2b14660da53a856be8fcff97a2f238343fccac2d042212e5a101eaf26fd12b78c86d0f6ce022bb79aa9815c67
    HEAD_REF "v${VERSION}"
    PATCHES
      use-kmpkg-zlib.patch
)

# default.sofa is a symlink to MIT_KEMAR_normal_pinna.sofa, 
# which can cause problems e.g. on Windows file systems.
if(EXISTS "${SOURCE_PATH}/share/default.sofa")
    file(REMOVE "${SOURCE_PATH}/share/default.sofa")
endif()
file(COPY_FILE "${SOURCE_PATH}/share/MIT_KEMAR_normal_pinna.sofa" "${SOURCE_PATH}/share/default.sofa")

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS=OFF
        -DBUILD_STATIC_LIBS=${BUILD_STATIC}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME mysofa CONFIG_PATH lib/cmake/mysofa)
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
