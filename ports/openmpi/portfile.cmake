kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

string(REGEX REPLACE [[^([0-9]+[.][0-9]+).*$]] [[\1]] OpenMPI_SHORT_VERSION "${VERSION}")

kmpkg_download_distfile(ARCHIVE
    URLS "https://download.open-mpi.org/release/open-mpi/v${OpenMPI_SHORT_VERSION}/openmpi-${VERSION}.tar.gz"
    FILENAME "openmpi-${VERSION}.tar.gz"
    SHA512 34d8db42b93d79f178fea043ff8b5565e646b4935be6fa57fff6674030e901b4c84012c800304a6ce639738beb04191fe78a9372eae626dd4a2f8c0839711e46
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
        keep_isystem.patch
)

kmpkg_find_acquire_program(PERL)
get_filename_component(PERL_PATH ${PERL} DIRECTORY)
kmpkg_add_to_path(${PERL_PATH})

# Put wrapper data dir side-by-side to wrapper executables dir instead of loosing debug data.
# KMPKG_CONFIGURE_MAKE_OPTIONS overwrites kmpkg_configure_make overwrites OPTIONS.
kmpkg_list(PREPEND KMPKG_CONFIGURE_MAKE_OPTIONS_DEBUG [[--datadir=\${prefix}/../tools/openmpi/debug/share]])
kmpkg_list(PREPEND KMPKG_CONFIGURE_MAKE_OPTIONS_RELEASE [[--datadir=\${prefix}/tools/openmpi/share]])
if(KMPKG_TARGET_IS_OSX)
    # This ensures that kmpkg-fixup-macho-rpath succeeds
    string(APPEND KMPKG_LINKER_FLAGS " -headerpad_max_install_names")
endif()

kmpkg_configure_make(
        COPY_SOURCE
        SOURCE_PATH ${SOURCE_PATH}
        OPTIONS
            --with-hwloc=internal
            --with-libevent=internal
            --with-pmix=internal
            --disable-mpi-fortran
        OPTIONS_DEBUG
            --enable-debug
)

kmpkg_install_make()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CURRENT_PORT_DIR}/mpi-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
