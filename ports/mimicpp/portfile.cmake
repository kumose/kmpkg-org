kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DNKpp/mimicpp
    REF "v${VERSION}"
    SHA512 936be384487f4c81a4e8af3bf16192a328bf88c5863ddf332c52526a506d69adddee2b36f04b7e25d0d0a838535ca8c47378cccc424702cff869ddd05347b25b
    HEAD_REF main
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMIMICPP_BUILD_TESTS=OFF
        -DMIMICPP_BUILD_EXAMPLES=OFF
        -DMIMICPP_CONFIGURE_DOXYGEN=OFF
        -DMIMICPP_ENABLE_AMALGAMATE_HEADERS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH cmake/mimicpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE_1_0.txt")
