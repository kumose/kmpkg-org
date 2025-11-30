kmpkg_buildpath_length_warning(37)
if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO apache/avro
    REF "release-${VERSION}"
    SHA512 8cc6ef3cf1e0a919118c8ba5817a1866dc4f891fa95873c0fe1b4b388858fbadee8ed50406fa0006882cab40807fcf00c5a2dcd500290f3868d9d06b287eacb6
    HEAD_REF master
    PATCHES
        avro.patch          # Private kmpkg build fixes
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/lang/c"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_DOCS=OFF
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
# the files are broken and there is no way to fix it because the snappy dependency has no pkgconfig file
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig")

kmpkg_copy_tools(TOOL_NAMES avroappend avrocat AUTO_CLEAN)

if(NOT KMPKG_TARGET_IS_WINDOWS)
    kmpkg_copy_tools(TOOL_NAMES avropipe avromod AUTO_CLEAN)
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static" AND NOT KMPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/lang/c/LICENSE")
