set(KMPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

kmpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL "https://gitlab.freedesktop.org"
    REPO "xdg/shared-mime-info"
    REF "${VERSION}"
    SHA512 "17b443c2c09a432d09e4c83db956f8c0c3a768cfa9ffb8c87cd2d7c9002b95d010094e2bc64dd35946205a0f8b2d87c4f8f0a1faec86443e2edd502aa8f7cc8f"
)

set(KMPKG_BUILD_TYPE release)  # only data

kmpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/tools/libxml2")

# msgfmt can't deal with drive letters on Windows, so we need to use a relative data dir
file(RELATIVE_PATH GETTEXTDATADIRREL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}" "${SOURCE_PATH}/data")
set(ENV{GETTEXTDATADIR} "${GETTEXTDATADIRREL}")

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dupdate-mimedb=false
        -Dbuild-tools=false
        -Dbuild-translations=false
        -Dbuild-tests=false
)

kmpkg_install_meson()

kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")

