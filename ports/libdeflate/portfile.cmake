kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ebiggers/libdeflate
    REF "v${VERSION}"
    SHA512 fa02fa0a6d241d3f71cf4238a3ac58968cbea0b66613c1647d6eea575379d60e93f4647f8b3921e8c31322e20521aa9953213d5465f7d10a27c57bdd7186d318
    HEAD_REF master
    PATCHES
        remove_wrong_c_flags_modification.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        compression   LIBDEFLATE_COMPRESSION_SUPPORT
        decompression LIBDEFLATE_DECOMPRESSION_SUPPORT
        gzip          LIBDEFLATE_GZIP_SUPPORT
        zlib          LIBDEFLATE_ZLIB_SUPPORT
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" LIBDEFLATE_BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" LIBDEFLATE_BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLIBDEFLATE_BUILD_SHARED_LIB=${LIBDEFLATE_BUILD_SHARED}
        -DLIBDEFLATE_BUILD_STATIC_LIB=${LIBDEFLATE_BUILD_STATIC}
        -DLIBDEFLATE_BUILD_GZIP=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/libdeflate")
kmpkg_fixup_pkgconfig()

if(KMPKG_TARGET_IS_WINDOWS)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libdeflate.h" "defined(LIBDEFLATE_DLL)" "1")
    elseif(NOT KMPKG_TARGET_IS_MINGW)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libdeflate.pc" " -ldeflate" " -ldeflatestatic")
        if(NOT KMPKG_BUILD_TYPE)
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libdeflate.pc" " -ldeflate" " -ldeflatestatic")
        endif()
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
