kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO open-source-parsers/jsoncpp
    REF "${VERSION}"
    SHA512 006d81f9f723dcfe875ebc2147449c07c5246bf97dd7b9eee1909decc914b051d6f3f06feb5c3dfa143d28773fb310aabb04a81dc447cc61513309df8eba8b08
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" JSONCPP_STATIC)
string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" STATIC_CRT)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS 
        -DJSONCPP_WITH_CMAKE_PACKAGE=ON
        -DBUILD_STATIC_LIBS=${JSONCPP_STATIC}
        -DJSONCPP_STATIC_WINDOWS_RUNTIME=${STATIC_CRT}
        -DJSONCPP_WITH_PKGCONFIG_SUPPORT=ON
        -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF
        -DJSONCPP_WITH_TESTS=OFF
        -DJSONCPP_WITH_EXAMPLE=OFF
        -DBUILD_OBJECT_LIBS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/jsoncpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
