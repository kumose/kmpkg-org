kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hanickadot/compile-time-regular-expressions
    REF "v${VERSION}"
    SHA512 4bed66b8adbf1de4f73963370e8b210787ace2f50d956cac141f1353c6a4e0ed0dcd62eb61cf54ae3e64875752ffdc04b67985a25aa50a2a245bc9039ab39f46
    HEAD_REF main
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCTRE_BUILD_TESTS=OFF
        -DCTRE_BUILD_PACKAGE=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/ctre")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
