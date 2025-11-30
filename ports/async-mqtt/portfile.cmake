set(KMPKG_BUILD_TYPE release) #header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO redboltz/async_mqtt
    REF "${VERSION}"
    SHA512 618bcd8357fd560e6b92a1bce08da0259f59d53bcfa9aed9890f182cb6f20415cff2595f31a3ca68b6e9c7b1caed3499a2e1915cd84a43dabf2e1e324c029ac1
    HEAD_REF main
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tls ASYNC_MQTT_USE_TLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DASYNC_MQTT_BUILD_TOOLS=OFF
        -DASYNC_MQTT_BUILD_EXAMPLES=OFF
        -DASYNC_MQTT_BUILD_UNIT_TESTS=OFF
        -DASYNC_MQTT_BUILD_SYSTEM_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME async_mqtt_iface CONFIG_PATH "lib/cmake/async_mqtt_iface")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
