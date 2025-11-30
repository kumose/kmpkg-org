kmpkg_download_distfile(
    MISSING_CSTDINT_IMPORT_PATCH
    URLS https://github.com/lu-zero/mfx_dispatch/commit/d6241243f85a0d947bdfe813006686a930edef24.patch?full_index=1
    FILENAME fix-missing-cstdint-import-d6241243f85a0d947bdfe813006686a930edef24.patch
    SHA512 5d2ffc4ec2ba0e5859d01d2e072f75436ebc3e62e0f6580b5bb8b9f82fe588e7558a46a1fdfa0297a782c0eeb8f50322258d0dd9e41d927cc9be496727b61e44
)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lu-zero/mfx_dispatch
    REF "${VERSION}"
    SHA512 12517338342d3e653043a57e290eb9cffd190aede0c3a3948956f1c7f12f0ea859361cf3e534ab066b96b1c211f68409c67ef21fd6d76b68cc31daef541941b0
    HEAD_REF master
    PATCHES
        fix-unresolved-symbol.patch
        fix-pkgconf.patch
        ${MISSING_CSTDINT_IMPORT_PATCH}
)

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    kmpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}" 
    )
    kmpkg_cmake_install()
    kmpkg_copy_pdbs()
else()
    if(KMPKG_TARGET_IS_MINGW)
        kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
    endif()
    kmpkg_configure_make(
        SOURCE_PATH "${SOURCE_PATH}"
        AUTOCONFIG
    )
    kmpkg_install_make()
endif()
kmpkg_fixup_pkgconfig()
  
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
