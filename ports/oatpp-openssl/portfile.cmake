set(OATPP_VERSION "1.3.0")

kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

# get the source
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oatpp/oatpp-openssl
    REF ${OATPP_VERSION}
    SHA512 a358a98e4c7e779c4c799e55667af67530fea537103500bf07b62ee434e87241c8ce3899bd19945a942b81ae9df86e318f0a725a56f4cb7cfceb0f98e3c0378b
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DOATPP_BUILD_TESTS:BOOL=OFF"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME oatpp-openssl CONFIG_PATH "lib/cmake/oatpp-openssl-${OATPP_VERSION}")
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
