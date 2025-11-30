message(WARNING "You will need to install sytemd dependencies to build sdbus-cpp:\nsudo apt install libsystemd-dev\n")

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Kistler-Group/sdbus-cpp
    REF "v${VERSION}"
    SHA512 4247d49f0d5231e2768c0c96fa9c266bbcc340292c9c3d748f9c37ff992b82301faea798300f916e9a5c992d77adfe56186866c91a4c7d4157750ff09ba5a047
)


kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tool   SDBUSCPP_BUILD_CODEGEN
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        -DSDBUSCPP_BUILD_LIBSYSTEMD=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME sdbus-c++ CONFIG_PATH lib/cmake/sdbus-c++)
kmpkg_fixup_pkgconfig()
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/debug/bin"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING" "${SOURCE_PATH}/COPYING-LGPL-Exception")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

if ("tool" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES sdbus-c++-xml2cpp AUTO_CLEAN)
endif()
