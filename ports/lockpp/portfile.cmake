kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Curve/lockpp
    REF "v${VERSION}"
    SHA512 ce2572ff53096a53cda722e47bbd23e4c3a8b3856de9dfe775b7468cd5f7fcbc86412457af091b8977dd0b41d161c103b679c7a98016f6e9d3ab70aaa360648f
    HEAD_REF master
)

kmpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH})
kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
