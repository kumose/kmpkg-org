kmpkg_download_distfile(tarball
    URLS "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgmepp/gpgmepp-${VERSION}.tar.xz"
         "https://gnupg.org/ftp/gcrypt/gpgme/gpgmepp-${VERSION}.tar.xz"
    FILENAME "gpgmepp-${VERSION}.tar.xz"
    SHA512 ed98f5dfd45efa216d0fc983ad650b46235b28a8e4faaf4349bc8e14cf76758e3099cfdc61e549f07e57d663e82550f373641f67303c5f2891b00fa5b419e927
)
kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${tarball}"
    PATCHES
        cmake-config.diff
        dependencies.diff
)
file(WRITE "${SOURCE_PATH}/VERSION" "${VERSION}")

kmpkg_find_acquire_program(PKGCONFIG)
set(ENV{PKG_CONFIG} "${PKGCONFIG}")

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" ENABLE_SHARED)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" ENABLE_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
        -DENABLE_SHARED=${ENABLE_SHARED}
        -DENABLE_STATIC=${ENABLE_STATIC}
)
kmpkg_cmake_install()
kmpkg_copy_pdbs() 
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/Gpgmepp")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.LIB")
