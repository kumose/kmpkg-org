set(OATPP_VERSION "1.3.0")

kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oatpp/oatpp-mongo
    REF ${OATPP_VERSION}
    SHA512 11f4164948feb63ed3f5e8554a54348e29cd4d90333761f98c37f4eb49f129c6589955755e8e052c5c29e6b2980f1bb899657415d6480c3ae7a50fc2445afbfe
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DOATPP_BUILD_TESTS:BOOL=OFF"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME oatpp-mongo CONFIG_PATH lib/cmake/oatpp-mongo-${OATPP_VERSION})
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
