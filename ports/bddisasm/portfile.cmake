kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO bitdefender/bddisasm
    REF "v${VERSION}"
    SHA512 5c1b8b8b9a29db76ce6197674e662fdc526e89372a84f7fac8e74cf4cc53bfab8d55c096cdb3f344fcfaa6a4d54a5bef79e8f1cf9131e497636072523b2cf3ec
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBDD_INCLUDE_TOOL=OFF
)

kmpkg_cmake_install()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/bddisasm)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")

kmpkg_fixup_pkgconfig()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
