kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jrouwe/JoltPhysics
    REF "v${VERSION}"
    SHA512 353b2cdc791b46513dbf90b4833988a4c7a4c541ea711813102fc3c488b5b19442092d77e715ae07c8e24a63e7046e975d6d9cb560f9777701c354a18032f9b4
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" USE_STATIC_CRT)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        debugrenderer       DEBUG_RENDERER_IN_DEBUG_AND_RELEASE
        profiler            PROFILER_IN_DEBUG_AND_RELEASE
        rtti                CPP_RTTI_ENABLED
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build"
    OPTIONS
        -DTARGET_UNIT_TESTS=OFF
        -DTARGET_HELLO_WORLD=OFF
        -DTARGET_PERFORMANCE_TEST=OFF
        -DTARGET_SAMPLES=OFF
        -DTARGET_VIEWER=OFF
        -DCROSS_PLATFORM_DETERMINISTIC=OFF
        -DINTERPROCEDURAL_OPTIMIZATION=OFF
        -DUSE_STATIC_MSVC_RUNTIME_LIBRARY=${USE_STATIC_CRT}
        -DENABLE_ALL_WARNINGS=OFF
        -DOVERRIDE_CXX_FLAGS=OFF
        ${FEATURE_OPTIONS}
    OPTIONS_RELEASE
        -DGENERATE_DEBUG_SYMBOLS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_cmake_config_fixup(PACKAGE_NAME Jolt CONFIG_PATH "lib/cmake/Jolt")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
