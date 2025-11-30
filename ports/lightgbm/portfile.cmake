kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/LightGBM
    REF v${VERSION}
    SHA512 f968f984a0881a5eadd898dded367b799b619e3cc80415dec8b623897e84d7e1e1034f20179125354b93759ea1b8a3e334cfa506427442810ef098bc93fd4634
    PATCHES
        kmpkg_lightgbm_use_kmpkg_libs.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        gpu USE_GPU
        openmp USE_OPENMP
)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(BUILD_STATIC_LIB "OFF")
else()
    set(BUILD_STATIC_LIB "ON")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_STATIC_LIB=${BUILD_STATIC_LIB}
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_copy_tools(TOOL_NAMES lightgbm AUTO_CLEAN)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
