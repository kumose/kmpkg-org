set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Tradias/asio-grpc
    REF "v${VERSION}"
    SHA512 27af296ed593aded51d6cd81a678684c9e1e5885719493f78e800d0bab91d2c0b28589b73d14db95b9a605ffd28187f85449e7000f5c2625f0e84ee108f22675
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DASIO_GRPC_CMAKE_CONFIG_INSTALL_DIR=share/asio-grpc
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
