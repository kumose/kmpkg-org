kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DaanDeMeyer/reproc
    REF "v${VERSION}"
    SHA512 d6c8abfc4fbef894310f4ad6250ddf269279bce13954ba6bc0147e0bf7e08f5a5e924ba079205881d6bf1dfe865e5f4389517d6d3bbafdede24ed328c549a991
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DREPROC++=ON
        -DREPROC_INSTALL_PKGCONFIG=OFF
        -DREPROC_INSTALL_CMAKECONFIGDIR=share
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

foreach(TARGET reproc reproc++)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME ${TARGET}
    )
endforeach()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
