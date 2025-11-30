set(KMPKG_BUILD_TYPE release) # Header-only library

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gershnik/intrusive_shared_ptr
    REF "v${VERSION}"
    SHA512 4977aeb12ee2ad79f7dbd240c7383d11e0dbd2821682705c351c8a1b55b17afa6eb99aa0618df494a3dd717b5b6e55b6d8dc555e3011c563369500382091ec93
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/isptr PACKAGE_NAME isptr)
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")
