set(filename readline-${VERSION}.tar.gz)
kmpkg_download_distfile(
    ARCHIVE
    URLS
        "https://ftpmirror.gnu.org/gnu/readline/${filename}"
        "https://ftp.gnu.org/gnu/readline/${filename}"
    FILENAME "${filename}"
    SHA512 513002753dcf5db9213dbbb61d51217245f6a40d33b1dd45238e8062dfa8eef0c890b87a5548e11db959e842724fb572c4d3d7fb433773762a63c30efe808344
)

kmpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

kmpkg_make_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        --with-curses=yes
        --disable-install-examples
)
kmpkg_make_install()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/tools"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
