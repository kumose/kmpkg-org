kmpkg_download_distfile(ARCHIVE
    URLS "http://download.savannah.nongnu.org/releases/acl/acl-${VERSION}.tar.xz"
         "https://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/acl/acl-${VERSION}.tar.xz"
         
    FILENAME "acl-${VERSION}.tar.xz"
    SHA512 c2d061dbfd28c00cecbc1ae614d67f3138202bf4d39b383f2df4c6a8b10b830f33acec620fb211f268478737dde4037d338a5823af445253cb088c48a135099b
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE ${ARCHIVE}
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

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/doc/COPYING.LGPL")
