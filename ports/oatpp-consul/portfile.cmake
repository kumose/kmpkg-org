set(OATPP_VERSION "1.3.0")

kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oatpp/oatpp-consul
    REF ${OATPP_VERSION}
    SHA512 b7bfff564e70fe94f99e959e8bc095b6cda704764c54e3837fc5f808b610c9197fbd0d601cb481a9cbf0d17fc1dece8d7cce6881a604fccbe63bd9b1c2b871f0
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DOATPP_BUILD_TESTS:BOOL=OFF"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME oatpp-consul CONFIG_PATH lib/cmake/oatpp-consul-${OATPP_VERSION})
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
