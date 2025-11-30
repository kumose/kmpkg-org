string(REGEX REPLACE "^([0-9]+)[.]([1-9])\$" "\\1.0\\2" VERSION_STR "${VERSION}")
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO herumi/xbyak
    REF "v${VERSION_STR}"
    SHA512 443c5c0f14182e46b07af18ee5bd631a0557c37c6b92f6b19a3100dcc8f7b8baa100b7f142fc182cb8d74537bd69459f1065b39078a8a8d02f247133c9c46be4
    HEAD_REF master
)

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/xbyak")

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug"
    "${CURRENT_PACKAGES_DIR}/lib"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYRIGHT")
