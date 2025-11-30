kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO aws/s2n-tls
    REF "v${VERSION}"
    SHA512 bee235eb74559651140c3797a13011979764b7ccd879ce3abe3f2cc651aac24683af489037822bfbcc73a66277a939dcedd68a20f36b7e960942f7933a362343 
    PATCHES
        fix-cmake-target-path.patch
        openssl.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tests   BUILD_TESTING
)

set(EXTRA_ARGS)
if(KMPKG_TARGET_ARCHITECTURE STREQUAL "wasm32")
    set(EXTRA_ARGS "-DS2N_NO_PQ=TRUE")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${EXTRA_ARGS}
        ${FEATURE_OPTIONS}
        -DUNSAFE_TREAT_WARNINGS_AS_ERRORS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/s2n/cmake)

if(BUILD_TESTING)
    message(STATUS "Testing")
    kmpkg_cmake_build(TARGET test LOGFILE_BASE test)
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/lib/s2n"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/lib/s2n"
    "${CURRENT_PACKAGES_DIR}/share/s2n/modules"
)

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
