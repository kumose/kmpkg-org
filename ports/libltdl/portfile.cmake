kmpkg_download_distfile(ARCHIVE
    URLS "https://ftpmirror.gnu.org/libtool/libtool-${VERSION}.tar.xz"
         "https://ftp.gnu.org/pub/gnu/libtool/libtool-${VERSION}.tar.xz"
    FILENAME "gnu-libtool-${VERSION}.tar.xz"
    SHA512 eed207094bcc444f4bfbb13710e395e062e3f1d312ca8b186ab0cbd22dc92ddef176a0b3ecd43e02676e37bd9e328791c59a38ef15846d4eae15da4f20315724
)

kmpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

kmpkg_list(SET OPTIONS "")
if(KMPKG_TARGET_IS_WINDOWS)
    string(APPEND KMPKG_C_FLAGS " -D_CRT_SECURE_NO_WARNINGS")
    string(APPEND KMPKG_CXX_FLAGS " -D_CRT_SECURE_NO_WARNINGS")
    if(NOT KMPKG_TARGET_IS_MINGW)
        kmpkg_list(APPEND OPTIONS ac_cv_header_dirent_h=no) # Ignore kmpkg port dirent
    endif()
endif()

kmpkg_make_configure(
    SOURCE_PATH "${SOURCE_PATH}/libltdl"
    AUTORECONF
    OPTIONS
        --enable-ltdl-install
        ${OPTIONS}
)
kmpkg_make_install()

file(COPY "${CURRENT_PORT_DIR}/libtoolize-ltdl-no-la" DESTINATION "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}")
file(CHMOD "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}/libtoolize-ltdl-no-la" FILE_PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ GROUP_EXECUTE
    WORLD_READ WORLD_EXECUTE
)
file(COPY "${CURRENT_PORT_DIR}/kmpkg-port-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/libltdl/COPYING.LIB")
