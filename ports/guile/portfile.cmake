kmpkg_download_distfile(GUILE_ARCHIVE 
    URLS
        "https://ftpmirror.gnu.org/guile/guile-${VERSION}.tar.gz"    
        "https://ftp.gnu.org/gnu/guile/guile-${VERSION}.tar.gz"
    FILENAME "guile-${VERSION}.tar.gz"
    SHA512 8b0e6354fdfccd009fd92a5618828f8a8343faf20d1d3698be77a6ef7a8fe56ce633fd1239520e6a6be511ba4ca75eb90c8a81c45888b8b73d938cd2908d7a1f
)

kmpkg_extract_source_archive(GUILE_SOURCES ARCHIVE "${GUILE_ARCHIVE}")

kmpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/tools/gperf")

kmpkg_configure_make(
    SOURCE_PATH "${GUILE_SOURCES}"
    ADD_BIN_TO_PATH
    AUTOCONFIG
)
kmpkg_install_make()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_fixup_pkgconfig()

if (NOT KMPKG_BUILD_TYPE)
    foreach(file guile-tools guile-config guild)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/${file}" "${CURRENT_INSTALLED_DIR}/debug/../tools/guile/debug/bin" "`dirname $0`" IGNORE_UNCHANGED)
    endforeach()
  kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/guile-config" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../../..")
endif()
foreach(file guile-tools guile-config guild)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/${file}" "${CURRENT_INSTALLED_DIR}/tools/guile/bin" "`dirname $0`" IGNORE_UNCHANGED)
endforeach()
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/guile-config" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../..")

kmpkg_install_copyright(FILE_LIST "${GUILE_SOURCES}/COPYING.LESSER")
