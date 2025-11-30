kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO stevemk14ebr/PolyHook_2_0
    REF 4c8872e207e76ea43fd23f802e3bf5acb43fee8a
    SHA512 f3baec4fc99e90221ce1b663c4fa10516a16c777135cca457e4b1de5e121c87b6a8eb5ac6392b75ee1c41e9e5a15a73171136fd3adfb3ff51ffaf0f909c58dd3
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        exception POLYHOOK_FEATURE_EXCEPTION
        detours   POLYHOOK_FEATURE_DETOURS
        inlinentd POLYHOOK_FEATURE_INLINENTD
        pe        POLYHOOK_FEATURE_PE
        virtuals  POLYHOOK_FEATURE_VIRTUALS
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIB)

if (KMPKG_CRT_LINKAGE STREQUAL "static")
    set(BUILD_STATIC_RUNTIME ON)
else()
    set(BUILD_STATIC_RUNTIME OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
      -DPOLYHOOK_BUILD_SHARED_LIB=${BUILD_SHARED_LIB}
      -DPOLYHOOK_BUILD_STATIC_RUNTIME=${BUILD_STATIC_RUNTIME}
      -DPOLYHOOK_USE_EXTERNAL_ASMJIT=ON
      -DPOLYHOOK_USE_EXTERNAL_ASMTK=ON
      -DPOLYHOOK_USE_EXTERNAL_ZYDIS=ON
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME PolyHook_2 CONFIG_PATH lib/PolyHook_2)

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
