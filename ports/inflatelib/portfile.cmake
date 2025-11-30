kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/inflatelib
    REF "v${VERSION}"
    SHA512 75c9bd5cca52813ccb7ff5dd048783c8865b7fdcdab406849019a321c49c3b74b831d0529549168b78bb4a51fcebbe6e945ca6309e60c4c5a3c0290d17d07cee
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DINFLATELIB_TEST=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "cmake")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
