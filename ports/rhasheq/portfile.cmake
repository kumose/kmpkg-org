kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO offscale/rhasheq
    REF cf5442f6468871beb6088991501e6ba052fe4467
    SHA512 2be63bc32c7cea35eefbcc7186255e9cd8ba6ed4b03cb9ee2e62740fe17ad74a81ee7e4ada37f4a2dca99a82becf790d6aa86822cdbeba3972cf11d54095ca91
    HEAD_REF master
    PATCHES
        find-rhash.patch
)

file(REMOVE "${SOURCE_PATH}/cmake/modules/FindLibRHash.cmake")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
