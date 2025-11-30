if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tree-sitter/tree-sitter-c
    REF "v${VERSION}"
    SHA512 51cf052230ee835d4ae5e6c5adb24aeaeba3b4f106aceefaf4000bd0e57321946f1b3e3b0f9ea71d1c17a618604c6c7269c80c3ecc5ca17e22c883ff5ce4c304
    HEAD_REF master
    PATCHES
        pkgconfig.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DTREE_SITTER_CLI=${CURRENT_HOST_INSTALLED_DIR}/tools/tree-sitter-cli/tree-sitter${KMPKG_HOST_EXECUTABLE_SUFFIX}"
        -DTREE_SITTER_REUSE_ALLOCATOR=ON
)
kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
