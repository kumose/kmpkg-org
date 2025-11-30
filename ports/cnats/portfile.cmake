kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nats-io/nats.c
    REF "v${VERSION}"
    SHA512 2edd9c19ca06f866696f2125fc1452568ad255ff09d26e58eb9c64e21e1d4fbfae208edc0f31eb93f87470f365b5701109f526d75ba5c8f4f0458766677ab2a7
    HEAD_REF main
    PATCHES
        fix-sodium-dep.patch
        fix_install_path.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "streaming"  NATS_BUILD_STREAMING
)

if (KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    list(APPEND OPTIONS -DNATS_BUILD_LIB_SHARED=ON)
    list(APPEND OPTIONS -DNATS_BUILD_LIB_STATIC=OFF)
    list(APPEND OPTIONS -DBUILD_TESTING=OFF)
    list(APPEND OPTIONS -DNATS_BUILD_USE_SODIUM=ON)
else()
    list(APPEND OPTIONS -DNATS_BUILD_LIB_SHARED=OFF)
    list(APPEND OPTIONS -DNATS_BUILD_LIB_STATIC=ON)
    list(APPEND OPTIONS -DBUILD_TESTING=ON)
    if(KMPKG_TARGET_IS_WINDOWS)
        list(APPEND OPTIONS -DNATS_BUILD_USE_SODIUM=OFF)
    else()
        list(APPEND OPTIONS -DNATS_BUILD_USE_SODIUM=ON)
    endif()
endif()

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        ${OPTIONS}
        -DNATS_BUILD_TLS_USE_OPENSSL_1_1_API=ON
        -DNATS_BUILD_EXAMPLES=OFF
)

kmpkg_cmake_install(ADD_BIN_TO_PATH)

if(KMPKG_TARGET_IS_WINDOWS)
    if (KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/nats.dll")
            file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/bin")
            file(RENAME "${CURRENT_PACKAGES_DIR}/lib/nats.dll" "${CURRENT_PACKAGES_DIR}/bin/nats.dll")
        endif()
        if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/natsd.dll")
            file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/bin")
            file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/natsd.dll" "${CURRENT_PACKAGES_DIR}/debug/bin/natsd.dll")
        endif()
    endif()
endif()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

if(KMPKG_TARGET_IS_WINDOWS)
    if (KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        if(EXISTS "${CURRENT_PACKAGES_DIR}/share/cnats/cnats-config-debug.cmake")
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/cnats/cnats-config-debug.cmake" 
                "\${_IMPORT_PREFIX}/debug/lib/natsd.dll" "\${_IMPORT_PREFIX}/debug/bin/natsd.dll")
        endif()
        if(EXISTS "${CURRENT_PACKAGES_DIR}/share/cnats/cnats-config-release.cmake")
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/cnats/cnats-config-release.cmake" 
                "\${_IMPORT_PREFIX}/lib/nats.dll" "\${_IMPORT_PREFIX}/bin/nats.dll")
        endif()
    endif()
endif()

kmpkg_fixup_pkgconfig()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

