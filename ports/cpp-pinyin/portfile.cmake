kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wolfgitpr/cpp-pinyin
    REF  "${VERSION}"
    SHA512 5ad5425f5c804607c90c801fac722971a6ddac39914807b9a0885dfcdcc0c2afc577893956164af4c2e1d8f87a3a63be884215d84be37e861abc25b98ab565ec
    HEAD_REF main
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" CPP_PINYIN_BUILD_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCPP_PINYIN_BUILD_STATIC=${CPP_PINYIN_BUILD_STATIC}
        -DCPP_PINYIN_BUILD_TESTS=FALSE
        -DCPP_PINYIN_KMPKG_DICT_DIR=${CURRENT_PACKAGES_DIR}/share/${PORT}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)
