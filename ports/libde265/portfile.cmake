kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO strukturag/libde265
    REF "v${VERSION}"
    SHA512 bda239b4827c81552855dc540724b74c86f6b02bcd0fe556650bc16d665a8eed1ddbde76ac0972d26b3002b14575bb9b6f70b367c39eb7de45c5c9df324e3d05
    HEAD_REF master
    PATCHES
        fix-interface-include.patch
        pkgconfig-cxx-linkage.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DENABLE_SDL=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libde265)
kmpkg_copy_tools(TOOL_NAMES dec265 AUTO_CLEAN)
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libde265/de265.h" "!defined(LIBDE265_STATIC_BUILD)" "0")
else()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libde265/de265.h" "!defined(LIBDE265_STATIC_BUILD)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
