kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nibanks/msh3
    REF v${VERSION}
    SHA512 0573647b2bea669b34343379319702513da884949b45b2e678aa6c9677ed8e5947ef85e6dcf47f5e5b798c9bfff62b41df53f65848a465b4b37596f5fefebbe6
    HEAD_REF main
    PATCHES
        dependencies_fix.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMSH3_INSTALL_PKGCONFIG=ON
        -DMSH3_USE_EXTERNAL_LSQPACK=ON
        -DMSH3_USE_EXTERNAL_MSQUIC=ON
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
