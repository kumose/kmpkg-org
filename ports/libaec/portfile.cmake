kmpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL https://gitlab.dkrz.de
    REPO k202009/libaec
    REF v1.1.3
    SHA512 6f317d08ad7d003bc6664da147321eb87c924978f32bd28780a8ebf015e251019046b0cb16b78e776cd1957a7701215667f64686efb8e5c6bae7c08528cede56
    PATCHES
        static-shared.patch
        cmake-config.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH "cmake")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
