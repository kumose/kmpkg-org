kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.com
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lv2/sratom
    REF "v${VERSION}"
    SHA512 4065c5fd79823f51f6781528115f0468aaf9acfd0dfd1632a55ee7e7d4bd26969984755e6af6060a0238f3832be21bf1b3f38fdaa116b4bc2247e842fcfff6f2
    HEAD_REF master
)

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_install_meson()

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
