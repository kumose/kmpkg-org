kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xiph/opus
    REF "v${VERSION}"
    SHA512 4ffefd9c035671024f9720c5129bfe395dea04f0d6b730041c2804e89b1db6e4d19633ad1ae58855afc355034233537361e707f26dc53adac916554830038fab
    HEAD_REF main
    PATCHES fix-pkgconfig-version.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        avx2 AVX2_SUPPORTED
)

set(STACK_PROTECTOR ON)
set(ADDITIONAL_OPUS_OPTIONS "")
if(KMPKG_TARGET_IS_MINGW)
    set(STACK_PROTECTOR OFF)
    string(APPEND KMPKG_C_FLAGS "-D_FORTIFY_SOURCE=0")
    string(APPEND KMPKG_CXX_FLAGS "-D_FORTIFY_SOURCE=0")
    if(KMPKG_TARGET_ARCHITECTURE MATCHES "^(ARM|arm)64$")
        list(APPEND ADDITIONAL_OPUS_OPTIONS "-DOPUS_USE_NEON=OFF") # for version 1.3.1 (remove for future Opus release)
        list(APPEND ADDITIONAL_OPUS_OPTIONS "-DOPUS_DISABLE_INTRINSICS=ON") # for HEAD (and future Opus release)
    endif()
elseif(KMPKG_TARGET_IS_WINDOWS)
    if(KMPKG_CRT_LINKAGE STREQUAL "static")
        list(APPEND ADDITIONAL_OPUS_OPTIONS "-DOPUS_STATIC_RUNTIME=ON")
    endif()
elseif(KMPKG_TARGET_IS_EMSCRIPTEN)
    set(STACK_PROTECTOR OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        -DPACKAGE_VERSION=${VERSION}
        -DOPUS_STACK_PROTECTOR=${STACK_PROTECTOR}
        -DOPUS_INSTALL_PKG_CONFIG_MODULE=ON
        -DOPUS_INSTALL_CMAKE_CONFIG_MODULE=ON
        -DOPUS_BUILD_PROGRAMS=OFF
        -DOPUS_BUILD_TESTING=OFF
        ${ADDITIONAL_OPUS_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        OPUS_USE_NEON
        OPUS_DISABLE_INTRINSICS
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Opus)
kmpkg_fixup_pkgconfig(SYSTEM_LIBRARIES m)


file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake"
                    "${CURRENT_PACKAGES_DIR}/lib/cmake"
                    "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
