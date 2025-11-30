kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lballabio/QuantLib
    REF "v${VERSION}"
    SHA512 6cc9102069644a8d333fed962a02e4fed1771a0b5c110fa7fcf538ce51a109b3ed2c2ace24fb20b67d13aa1feb2e9290a3e0549e8c67e7806a9fbd886c85f357
    HEAD_REF master
)

if (KMPKG_TARGET_IS_WINDOWS)
    # This can (and should) be removed if QuantLib ever supports dynamically linking on Windows
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DQL_BUILD_EXAMPLES=OFF
        -DQL_BUILD_TEST_SUITE=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME QuantLib CONFIG_PATH lib/cmake/QuantLib)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Remove the "bin" directories if we are building static libraries
if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

# Install custom usage
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" @ONLY)

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE.TXT" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
