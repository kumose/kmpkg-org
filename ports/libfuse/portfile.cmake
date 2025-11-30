kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libfuse/libfuse
    REF "fuse-${VERSION}"
    SHA512 a39bb630f8e57a635980e153b9209a4b804569656feddb46fe8bef02c053533a6037fcc767d03efd5f8bebffed1ff55eb5f49b323ab71e8913008f994cffca77
    HEAD_REF master
)

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dutils=false
)

kmpkg_install_meson()

kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
