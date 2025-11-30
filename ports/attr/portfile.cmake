kmpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.nongnu.org/releases/attr/attr-${VERSION}.tar.xz"
         "https://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/attr/attr-${VERSION}.tar.xz"
    FILENAME "attr-${VERSION}.tar.xz"
    SHA512 f587ea544effb7cfed63b3027bf14baba2c2dbe3a9b6c0c45fc559f7e8cb477b3e9a4a826eae30f929409468c50d11f3e7dc6d2500f41e1af8662a7e96a30ef3
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

kmpkg_list(SET options)
if("nls" IN_LIST FEATURES)
    kmpkg_list(APPEND options "--enable-nls")
    kmpkg_add_to_path(PREPEND "${CURRENT_HOST_INSTALLED_DIR}/tools/gettext/bin")
else()
    set(ENV{AUTOPOINT} true) # true, the program
    kmpkg_list(APPEND options "--disable-nls")
endif()

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS
        ${options}
)

kmpkg_install_make()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/etc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/doc/COPYING.LGPL")
