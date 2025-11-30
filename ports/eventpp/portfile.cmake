set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wqking/eventpp
    REF "v${VERSION}"
    SHA512 b39994e9bd581d6bb61b634c434c46075e41ec2217e1174578fefd206a927bd725744ae0724d319cde8f2b2a43d2e030a04c271197500d94c6b1afd849f779fd
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/eventpp")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")
file(REMOVE "${CURRENT_PACKAGES_DIR}/share/eventpp/license" "${CURRENT_PACKAGES_DIR}/share/eventpp/readme.md")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/license")
