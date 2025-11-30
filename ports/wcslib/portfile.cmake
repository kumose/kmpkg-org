kmpkg_download_distfile(archive
    URLS "http://www.atnf.csiro.au/people/mcalabre/WCS/wcslib-${VERSION}.tar.bz2"
    FILENAME "wcslib-${VERSION}.tar.bz2"
    SHA512 1989f8f5788fd6d9fa102b771ad7db188b0899f716e11360516c96742f81f50755881279f90fce388451e8857f24003c85751f06aea83377e04bb5230523469f
)

kmpkg_extract_source_archive(
    src
    ARCHIVE "${archive}"
)

kmpkg_configure_make(
    SOURCE_PATH ${src}
    COPY_SOURCE
    OPTIONS
        --disable-flex
        --disable-fortran
        --without-pgplot
        --without-cfitsio)

kmpkg_install_make(MAKEFILE GNUmakefile)
kmpkg_fixup_pkgconfig()
kmpkg_install_copyright(FILE_LIST "${src}/COPYING")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
