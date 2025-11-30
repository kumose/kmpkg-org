kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.gnome.org/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GNOME/libadwaita
    REF "${VERSION}"
    SHA512 5cea6396bab3439fb3ddef95fe86bc84955ce1eb426fc5dd323329eeab8a51e10de5f4d9c45380f905ceea43e094362a577a67386a3ddcefff362af030c8c7e3
    HEAD_REF main
    PATCHES
)

set(GLIB_TOOLS_DIR "${CURRENT_HOST_INSTALLED_DIR}/tools/glib")
set(SASSC_TOOLS_DIR "${CURRENT_HOST_INSTALLED_DIR}/tools/sassc")

kmpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -Dintrospection=disabled
        -Dtests=false
        -Dgtk_doc=false
        -Dexamples=false
        -Dvapi=false
    ADDITIONAL_BINARIES
        glib-genmarshal='${GLIB_TOOLS_DIR}/glib-genmarshal'
        glib-mkenums='${GLIB_TOOLS_DIR}/glib-mkenums'
        glib-compile-resources='${GLIB_TOOLS_DIR}/glib-compile-resources${KMPKG_HOST_EXECUTABLE_SUFFIX}'
        glib-compile-schemas='${GLIB_TOOLS_DIR}/glib-compile-schemas${KMPKG_HOST_EXECUTABLE_SUFFIX}'
        sassc='${SASSC_TOOLS_DIR}/bin/sassc${KMPKG_HOST_EXECUTABLE_SUFFIX}'
)

kmpkg_install_meson()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
