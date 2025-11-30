kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO redboltz/mqtt_cpp
    REF v${VERSION}
    SHA512
    a237c08ff741c9b85e30f476f0a6d4d67d6720f66d68ac49253ff463e4675f89d0d6b69038a9dfd5814694e48f24af735dee57aa66215c5e0d3279c688878b2f
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    -DMQTT_BUILD_EXAMPLES=OFF
    -DMQTT_BUILD_TESTS=OFF
    -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME mqtt_cpp_iface CONFIG_PATH lib/cmake/mqtt_cpp_iface)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE_1_0.txt")
