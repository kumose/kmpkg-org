kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libssh2/libssh2
    REF "libssh2-${VERSION}"
    SHA512 616efcd7f5c1fb1046104ebce70549e4756e2a55150efa2df5bb7123051d3bf336023cedcbfe932cd7c690a0b4d1f1a93c760ea39f1dba50c2b06d0945dca958
    HEAD_REF master
    PATCHES
        pkgconfig.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        zlib    ENABLE_ZLIB_COMPRESSION
)
if("openssl" IN_LIST FEATURES)
    list(APPEND FEATURE_OPTIONS "-DCRYPTO_BACKEND=OpenSSL")
elseif(KMPKG_TARGET_IS_WINDOWS)
    list(APPEND FEATURE_OPTIONS "-DCRYPTO_BACKEND=WinCNG")
else()
    message(FATAL_ERROR "Port ${PORT} only supports OpenSSL and WinCNG crypto backends.")
endif()
if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND FEATURE_OPTIONS "-DBUILD_STATIC_LIBS:BOOL=OFF")
endif()

kmpkg_find_acquire_program(PKGCONFIG)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_DEBUG_LOGGING=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libssh2)

if (KMPKG_TARGET_IS_WINDOWS)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libssh2.h" "defined(_WINDLL)" "1")
    endif()
    if(KMPKG_TARGET_STATIC_LIBRARY_PREFIX STREQUAL "")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libssh2.pc" " -lssh2" " -llibssh2")
        if(NOT KMPKG_BUILD_TYPE)
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libssh2.pc" " -lssh2" " -llibssh2")
        endif()
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/man")

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
