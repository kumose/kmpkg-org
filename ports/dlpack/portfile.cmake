set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dmlc/dlpack
    REF "v${VERSION}"
    SHA512 ff24ddf8a138f20aeede2708327d8239bd3cc4e2223a6fbce1589638dd2d844827ce6af1d3eb1a14165e608f424f5d4ff358c5f55600b150083c6c8b83e35afd
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -DBUILD_MOCK=FALSE
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/dlpack")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
