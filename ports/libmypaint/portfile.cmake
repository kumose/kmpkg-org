kmpkg_download_distfile(ARCHIVE
    URLS "https://github.com/mypaint/libmypaint/releases/download/v${VERSION}/libmypaint-${VERSION}.tar.xz"
    FILENAME "libmypaint-${VERSION}.tar.xz"
    SHA512 e9413fd6a5336791ab3228a5ad9e7f06871d075c7ded236942f896a205ba44ea901a945fdc97b8be357453a1505331b59e824fe67500fbcda0cc4f11f79af608
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

kmpkg_make_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        --disable-i18n
        --disable-introspection
        --with-glib
)

kmpkg_make_install()

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
