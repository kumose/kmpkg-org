string(REGEX MATCH [[^[0-9][0-9]*\.[1-9][0-9]*]] VERSION_MAJOR_MINOR ${VERSION})

kmpkg_download_distfile(ARCHIVE
    URLS "https://download.gimp.org/pub/babl/${VERSION_MAJOR_MINOR}/babl-${VERSION}.tar.xz"
    FILENAME "babl-${VERSION}.tar.xz"
    SHA512 ff410c9839f4fe4d6afd4dec7e4d02af34b1c8a4edbc05483784ed82f91045b1102414fc1c58357866044b7f1ab499eda24fe744f5dd692af5804020c76b2382
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

set(feature_options "")
if("cmyk-icc" IN_LIST FEATURES)
    list(APPEND feature_options "-Dwith-lcms=true")
else()
    list(APPEND feature_options "-Dwith-lcms=false")
endif()

if("introspection" IN_LIST FEATURES)
    list(APPEND feature_options "-Denable-gir=true")
    kmpkg_get_gobject_introspection_programs(PYTHON3 GIR_COMPILER GIR_SCANNER)
else()
    list(APPEND feature_options "-Denable-gir=false")
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${feature_options}
        -Dwith-docs=false
    ADDITIONAL_BINARIES
        "g-ir-compiler='${GIR_COMPILER}'"
        "g-ir-scanner='${GIR_SCANNER}'"
)
kmpkg_install_meson()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
