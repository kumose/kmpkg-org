if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO charles-lunarg/vk-bootstrap
    REF "v${VERSION}"
    SHA512 d55752fbaa84ecf8c674eb9c8639553db2631024797e62b807078c95601dd711263381443d52ddd2ef6635d61ffcacd39650aa638363cf1d124ff0a37010c2d9
    HEAD_REF master
    PATCHES
        fix-targets.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DVK_BOOTSTRAP_TEST=OFF
        -DVK_BOOTSTRAP_INSTALL=ON
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
