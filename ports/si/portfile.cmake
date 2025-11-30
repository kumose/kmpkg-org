kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO bernedom/SI
    REF "${VERSION}"
    SHA512 499bf6cd1c68cf5195f15b94910d4f3973a040c2d217aab4eacaa29bfefc031b441639272cffb4b810fd27ff3a664d55284c1252da5e4504ebc768d1a3567f78
    HEAD_REF master
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSI_INSTALL_LIBRARY=ON
        -DSI_BUILD_TESTING=OFF
        -DSI_BUILD_DOC=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME SI CONFIG_PATH share/SI/cmake)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
