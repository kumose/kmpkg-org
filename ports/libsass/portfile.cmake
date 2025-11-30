kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sass/libsass
    REF "${VERSION}"
    SHA512 659828c854af391c10a16954425fbeeb5fa036189dea45555cd8046338f7469eb7f8d84134030ce644921514b8f397ef6070b56dfb116ea7ce94328d64576518
    HEAD_REF master
    PATCHES remove_compiler_flags.patch
)

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
)
kmpkg_install_make(MAKEFILE GNUmakefile)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
