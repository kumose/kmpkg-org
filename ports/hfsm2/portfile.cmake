kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO andrew-gresyk/HFSM2
    REF ${VERSION}
    SHA512 9e68404cd509f598b693521c2f12a0672053b62c848c1a20ba7a6f39116ee6abd25b94a58d2b4d62ab2c02b987218f441038d9c762cda73e7c0f215b95f92b4f
    HEAD_REF master
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DHFSM2_BUILD_TESTS=OFF
        -DHFSM2_BUILD_EXAMPLES=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/hfsm2 PACKAGE_NAME hfsm2)
kmpkg_fixup_pkgconfig()

# Remove empty directories if they exist
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug"
    "${CURRENT_PACKAGES_DIR}/lib"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
