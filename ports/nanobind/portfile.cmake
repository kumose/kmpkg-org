# nanobind distributes source code to build on-demand.
# The source code is installed into the 'share/${PORT}' directory with
# subdirectories for source `src` and header `include` files
set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
set(KMPKG_BUILD_TYPE release)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wjakob/nanobind
    REF "v${VERSION}"
    SHA512 05b2541896e64bb513f915ebc09820b2d3659efa9a1a4bdda9da79a761a23d84e41db22031c02ae816b1f729dab95efcb7c888e926dbb89fb4b34c8a329d59bf
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DNB_USE_SUBMODULE_DEPS:BOOL=OFF
        -DNB_TEST:BOOL=OFF
)

kmpkg_cmake_install()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
