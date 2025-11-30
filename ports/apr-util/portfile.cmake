kmpkg_download_distfile(ARCHIVE
  URLS "https://archive.apache.org/dist/apr/apr-util-${VERSION}.tar.bz2"
    FILENAME "apr-util-${VERSION}.tar.bz2"
    SHA512 8050a481eeda7532ef3751dbd8a5aa6c48354d52904a856ef9709484f4b0cc2e022661c49ddf55ec58253db22708ee0607dfa7705d9270e8fee117ae4f06a0fe
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
FEATURES
    crypto APU_HAVE_CRYPTO
    crypto CMAKE_REQUIRE_FIND_PACKAGE_OpenSSL
)

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
        PATCHES
            use-kmpkg-expat.patch
            apr.patch
            unglue.patch
    )

    kmpkg_cmake_configure(
      SOURCE_PATH "${SOURCE_PATH}"
      OPTIONS
        ${FEATURE_OPTIONS}
      OPTIONS_DEBUG
        -DDISABLE_INSTALL_HEADERS=ON
    )

    kmpkg_cmake_install()
    kmpkg_copy_pdbs()

    # Upstream include/apu.h.in has:
    # ```
    #elif defined(APU_DECLARE_STATIC)
    #define APU_DECLARE(type)            type __stdcall
    #define APU_DECLARE_NONSTD(type)     type __cdecl
    #define APU_DECLARE_DATA
    #elif defined(APU_DECLARE_EXPORT)
    #define APU_DECLARE(type)            __declspec(dllexport) type __stdcall
    #define APU_DECLARE_NONSTD(type)     __declspec(dllexport) type __cdecl
    #define APU_DECLARE_DATA             __declspec(dllexport)
    #else
    #define APU_DECLARE(type)            __declspec(dllimport) type __stdcall
    #define APU_DECLARE_NONSTD(type)     __declspec(dllimport) type __cdecl
    #define APU_DECLARE_DATA             __declspec(dllimport)
    #endif
    # ```
    # When building, BUILD_SHARED_LIBS sets APU_DECLARE_STATIC to 0 and APU_DECLARE_EXPORT to 1
    # Not BUILD_SHARED_LIBS sets APU_DECLARE_STATIC to 1 and APU_DECLARE_EXPORT to 0
    # When consuming APU_DECLARE_EXPORT is always 0 (assumed), so we need only embed the static or not setting
    # into the resulting headers:
    if(KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/apu.h" "defined(APU_DECLARE_STATIC)" "0")
    else()
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/apu.h" "defined(APU_DECLARE_STATIC)" "1")
    endif()
else()
    kmpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
    )

    if ("crypto" IN_LIST FEATURES)
        set(CRYPTO_OPTIONS 
            "--with-crypto=yes"
            "--with-openssl=${CURRENT_INSTALLED_DIR}")
    else()
        set(CRYPTO_OPTIONS "--with-crypto=no")
    endif()

    # To cross-compile you will need a triplet file that locates the tool chain and sets --host and --cache parameters of "./configure".
    # The ${KMPKG_PLATFORM_TOOLSET}.cache file must have been generated on the targeted host using "./configure -C".
    # For example, to target aarch64-linux-gnu, triplets/aarch64-linux-gnu.cmake should contain (beyond the standard content):
    # set(KMPKG_PLATFORM_TOOLSET aarch64-linux-gnu)
    # set(KMPKG_CHAINLOAD_TOOLCHAIN_FILE ${MY_CROSS_DIR}/cmake/Toolchain-${KMPKG_PLATFORM_TOOLSET}.cmake)
    # set(CONFIGURE_PARAMETER_1 --host=${KMPKG_PLATFORM_TOOLSET})
    # set(CONFIGURE_PARAMETER_2 --cache-file=${MY_CROSS_DIR}/autoconf/${KMPKG_PLATFORM_TOOLSET}.cache)
    if(CONFIGURE_PARAMETER_1)
        message(STATUS "Configuring apr-util with ${CONFIGURE_PARAMETER_1} ${CONFIGURE_PARAMETER_2} ${CONFIGURE_PARAMETER_3}")
    else()
        message(STATUS "Configuring apr-util")
    endif()

    kmpkg_configure_make(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
            "--prefix=${CURRENT_INSTALLED_DIR}"
            ${CRYPTO_OPTIONS}
            "--with-apr=${CURRENT_INSTALLED_DIR}/tools/apr"
            "--with-expat=${CURRENT_INSTALLED_DIR}"
            "${CONFIGURE_PARAMETER_1}"
            "${CONFIGURE_PARAMETER_2}"
            "${CONFIGURE_PARAMETER_3}"
    )

    kmpkg_install_make()
    kmpkg_fixup_pkgconfig()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/apr-util/bin/apu-1-config" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../..")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/apr-util/bin/apu-1-config" "${CURRENT_BUILDTREES_DIR}" "not/existing")
    if(NOT KMPKG_BUILD_TYPE)
      kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/apr-util/debug/bin/apu-1-config" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../../..")
      kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/apr-util/debug/bin/apu-1-config" "${CURRENT_BUILDTREES_DIR}" "not/existing")
    endif()
endif()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
