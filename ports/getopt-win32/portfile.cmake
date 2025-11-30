set(KMPKG_POLICY_ALLOW_RESTRICTED_HEADERS "enabled")

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ludvikjerabek/getopt-win
    REF v${VERSION}
    SHA512 9ca4e7ed7a1fe7bad9d9ef91b5e65c18a716f4c999818e3dd4f644fc861e1ae12e64255c27f12c0df3b1e44757d3d36c068682dd86d184c6f957b2cabda7bbf3
    HEAD_REF getopt_glibc_2.42_port
    PATCHES
        static-output-name.diff
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIBS)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
        -DBUILD_TESTING=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH  "lib/cmake/getopt")

if (KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/getopt.h" "defined(STATIC_GETOPT)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Legacy polyfill
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/unofficial-getopt-win32-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-getopt-win32")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
