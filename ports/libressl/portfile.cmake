if(EXISTS "${CURRENT_INSTALLED_DIR}/include/openssl/ssl.h")
    message(FATAL_ERROR "Can't build libressl if openssl is installed. Please remove openssl, and try install libressl again if you need it.")
endif()

kmpkg_download_distfile(
    LIBRESSL_SOURCE_ARCHIVE
    URLS "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${PORT}-${VERSION}.tar.gz"
         "https://github.com/libressl/portable/releases/download/v${VERSION}/${PORT}-${VERSION}.tar.gz"
    FILENAME "${PORT}-${VERSION}.tar.gz"
    SHA512 b06eccff7b332da38efbc5a039d8ee54bd26437f3d5957f59ac2d93b4464f181c9a665a2c957272be5d9f91f447720f6dfa29b4b72407279ac8a7722c322dac0
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${LIBRESSL_SOURCE_ARCHIVE}"
    PATCHES
        pkgconfig.diff
        aarch64-windows.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "tools" LIBRESSL_APPS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DLIBRESSL_INSTALL_CMAKEDIR=share/${PORT}
        -DLIBRESSL_TESTS=OFF
    OPTIONS_DEBUG
        -DLIBRESSL_APPS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup()

# libressl as openssl replacement
configure_file("${CURRENT_PORT_DIR}/kmpkg-cmake-wrapper.cmake.in" "${CURRENT_PACKAGES_DIR}/share/openssl/kmpkg-cmake-wrapper.cmake" @ONLY)

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES ocspcheck openssl DESTINATION "${CURRENT_PACKAGES_DIR}/tools/openssl" AUTO_CLEAN)
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/etc/ssl/certs"
    "${CURRENT_PACKAGES_DIR}/debug/etc/ssl/certs"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/share/man"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
