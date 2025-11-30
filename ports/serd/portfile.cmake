kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.com
    OUT_SOURCE_PATH SOURCE_PATH
    REPO drobilla/serd
    REF "v${VERSION}"
    SHA512 2dc168c31edaa2ae496703b5e5f03228b7520079efd0d5ed712629d97524cee8af5ebae754d51bcbecfcbe613b21f1a75eaad0c0f1bfc49b942e7868f7f7f891
    HEAD_REF main
)

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_install_meson()

kmpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_copy_tools(TOOL_NAMES serdi AUTO_CLEAN)
kmpkg_fixup_pkgconfig()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
