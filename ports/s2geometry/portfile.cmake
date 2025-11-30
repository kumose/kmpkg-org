if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/s2geometry
    REF v0.11.1
    SHA512 c500029c6e9cc412a29a8a74961688b0a504f60b1a7698ef84c0d0ae760e3c3f05e7068fb1154c9755d907f82e3bc09f8bf1d0ff629cbd3bad6e70169187dd37
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTS=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME s2)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/s2geometry" RENAME copyright)
file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/s2geometry")
