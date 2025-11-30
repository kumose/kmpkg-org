kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO moehoshio/NekoEvent
    REF v1.0.1
    SHA512 2c9579def648a0feaaf0763d11801b70260d8f56bd477fcafc9d45cb7c2c5c8ab365f77c925aad46a75aa85c5c0730efee9ace0b6a5f3025a3166a776908a8e7
    HEAD_REF main
)

set(KMPKG_BUILD_TYPE release)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DNEKO_EVENT_BUILD_TESTS=OFF
        -DNEKO_EVENT_AUTO_FETCH_DEPS=OFF
        -DNEKO_EVENT_ENABLE_MODULE=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/NekoEvent PACKAGE_NAME nekoevent)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
