kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO felixguendling/cista
    REF "v${VERSION}"
    SHA512 87679d9eba2b6ed1fe60b39163b13cebaee221127784b5906c82770455908375e6cdcca58d3994fb22eefe4d9605332ee2134c0420f5c11783868cffd7cfa0ee
    HEAD_REF master
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCISTA_INSTALL=ON
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cista)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
