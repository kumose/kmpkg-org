kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO guybrush77/rapidobj
    REF "v${VERSION}"
    SHA512 eddd03556348e44de60af8bd15b5f614ed2588e7c26e0b57cc436f65394d579f379b991126e6542374cfd4f2e110b305ce19135605adc60609448beb53e03d53
    HEAD_REF master
    PATCHES
        fix-build.patch
)

set(KMPKG_BUILD_TYPE release) # header-only port
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup()

kmpkg_fixup_pkgconfig()

file(
    REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug
    ${CURRENT_PACKAGES_DIR}/lib
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
