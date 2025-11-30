# Don't change to kmpkg_from_github: The raw repo lacks gettext macros.
kmpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libconfuse/libconfuse/releases/download/v${VERSION}/confuse-${VERSION}.tar.xz"
    FILENAME "libconfuse-confuse-${VERSION}.tar.xz"
    SHA512 93cc62d98166199315f65a2f6f540a9c0d33592b69a2c6a57fd17f132aecc6ece39b9813b96c9a49ae2b66a99b7eba1188a9ce9e360e1c5fb4b973619e7088a0
)
kmpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

kmpkg_find_acquire_program(FLEX)
get_filename_component(FLEX_DIR "${FLEX}" DIRECTORY)
kmpkg_add_to_path("${FLEX_DIR}")

set(ENV{AUTOPOINT} true) # true, the program

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS
        --disable-examples
        --disable-nls
)
kmpkg_install_make()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/confuse.h" "ifdef BUILDING_STATIC" "if 1")
endif()

file(INSTALL "${CURRENT_PORT_DIR}/unofficial-libconfuse-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-libconfuse")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
