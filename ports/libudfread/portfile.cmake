kmpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL https://code.videolan.org
    REPO videolan/libudfread
    REF ${VERSION}
    SHA512 63cdd8ce9b7525d17f8f685b87d1232334ebfe9ffcd48b3bb189231f4d3c88c11a19d3435be9252058d374b1cbd86eb38a045c969699730cb9729a541582f645
    PATCHES
        msvc.diff
)

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Denable_examples=false
)

kmpkg_install_meson()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
