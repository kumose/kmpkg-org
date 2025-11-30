set(PATCHES
    opensp_1.5.2-13.diff                   # http://deb.debian.org/debian/pool/main/o/opensp/opensp_1.5.2-13.diff.gz
    use-cpp-using-declarations.patch
)
if (KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_UWP)
    list(APPEND PATCHES windows_cmake_build.diff)   # https://invent.kde.org/packaging/craft-blueprints-kde/-/tree/master/libs/libopensp
endif()
if (KMPKG_TARGET_IS_UWP)
    list(APPEND PATCHES uwp_getenv_fix.diff)
endif()

kmpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/openjade/opensp/${VERSION}/OpenSP-${VERSION}.tar.gz"
    FILENAME "OpenSP-${VERSION}.tar.gz"
    SHA512 a7dcc246ba7f58969ecd6d107c7b82dede811e65f375b7aa3e683621f2c6ff3e7dccefdd79098fcadad6cca8bb94c2933c63f4701be2c002f9a56f1bbe6b047e
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    SOURCE_BASE ${VERSION}
    PATCHES ${PATCHES}
)

if (KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_UWP)
    kmpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
    )

    kmpkg_cmake_install()
else()
    if(KMPKG_TARGET_IS_OSX)
        # libintl links to those
        set(EXTRA_LIBS "-framework CoreFoundation -lintl -liconv") 
    endif()

    kmpkg_configure_make(
        AUTOCONFIG
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
            --disable-doc-build
            "LDFLAGS=${EXTRA_LIBS} \$LDFLAGS"
    )

    kmpkg_install_make()
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/opensp.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/opensp.pc" @ONLY)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
