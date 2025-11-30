kmpkg_download_distfile(tarball
    URLS "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-${VERSION}.tar.bz2"
         "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-${VERSION}.tar.bz2"
    FILENAME "gpgme-${VERSION}.tar.bz2"
    SHA512 ee58dc2a4273c740d5b9ef13cc655d5e600ddddd137fb85a781c31e8854829283b4ce241d7810a963d9a125d603213600f37e7d0c1ce3b3cf1b935e62cf60777
)
kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${tarball}"
    PATCHES
        disable-docs.patch
 )

kmpkg_make_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTORECONF
    OPTIONS
        --disable-gpgconf-test
        --disable-gpg-test
        --disable-gpgsm-test
        --disable-g13-test
        GPG_ERROR_CONFIG=/ # fake absolute path; gpgrt-config is used instead
    OPTIONS_RELEASE
        "GPGRT_CONFIG=${CURRENT_INSTALLED_DIR}/tools/libgpg-error/bin/gpgrt-config"
    OPTIONS_DEBUG
        "GPGRT_CONFIG=${CURRENT_INSTALLED_DIR}/tools/libgpg-error/debug/bin/gpgrt-config"
)

kmpkg_make_install()
kmpkg_copy_pdbs() 

# This port doesn't support the windows-only glib integration.
file(REMOVE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/gpgme-glib.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/gpgme-glib.pc")
kmpkg_fixup_pkgconfig()

set(install_prefix "${CURRENT_INSTALLED_DIR}")
if(KMPKG_HOST_IS_WINDOWS)
    string(REGEX REPLACE "^([a-zA-Z]):/" "/\\1/" install_prefix "${install_prefix}")
endif()
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/gpgme-config" "${install_prefix}" "`dirname $0`/../../..")
if(NOT KMPKG_BUILD_TYPE)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/gpgme-config" "${install_prefix}" "`dirname $0`/../../../..")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(COMMENT [[
The library is distributed under the terms of the GNU Lesser General Public License (LGPL).
The helper programs are distributed under the terms of the GNU General Public License (GPL).
There are additional notices about contributions that require these additional notices are distributed.
]]
    FILE_LIST
        "${SOURCE_PATH}/COPYING.LESSER"
        "${SOURCE_PATH}/COPYING"
        "${SOURCE_PATH}/LICENSES"
)
