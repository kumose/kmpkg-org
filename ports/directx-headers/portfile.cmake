kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/DirectX-Headers
    REF v${VERSION}
    SHA512 4d75cc0fdedc16b8c8e9361400da69afc728aef70818051239e4519837682aefa30d10fc816595f5f45bf5244c59632d4e29ffd4efe80c3b6f50d756586d3b36
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS -DDXHEADERS_INSTALL=ON -DDXHEADERS_BUILD_TEST=OFF -DDXHEADERS_BUILD_GOOGLE_TEST=OFF
)

kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH share/directx-headers/cmake)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
