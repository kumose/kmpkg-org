if(KMPKG_TARGET_IS_WINDOWS)
    set(KMPKG_BUILD_TYPE release) # Windows port only includes headers.
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "microsoft/LinuxTracepoints"
    REF "v${VERSION}"
    SHA512 baf27c967b2fa1fb8e8684951fd8e12e40fe9c23f5052a2d77c63eceab6ddfc112537422b97c37cfb0e479361fa8aedea6d8d7edfae91810f1ed696060fcb822
    HEAD_REF main)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools  BUILD_TOOLS)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/libtracepoint"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_SAMPLES=OFF
        -DBUILD_TESTS=OFF)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

if (BUILD_TOOLS)
    kmpkg_copy_tools(
        TOOL_NAMES tracepoint-register
        AUTO_CLEAN)
endif()

if(NOT KMPKG_TARGET_IS_WINDOWS)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME tracepoint
        CONFIG_PATH lib/cmake/tracepoint
        DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()

kmpkg_cmake_config_fixup(
    PACKAGE_NAME tracepoint-headers
    CONFIG_PATH lib/cmake/tracepoint-headers)

if(KMPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
