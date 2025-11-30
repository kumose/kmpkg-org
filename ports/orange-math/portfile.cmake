if (KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO orange-cpp/omath
    REF "v${VERSION}"
    SHA512 b2a1ffb8183b1f0310d2ca4851501c4312955d6e13c4253e87b28f74265895dad00151207123af07604d14f9964d6c32d1917a80b9d49d9cec948fa8728456a6
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" OMATH_SHARED)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "avx2"      OMATH_USE_AVX2
        "imgui"     OMATH_IMGUI_INTEGRATION
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DOMATH_USE_UNITY_BUILD=ON
        -DOMATH_BUILD_TESTS=OFF
        -DOMATH_THREAT_WARNING_AS_ERROR=OFF
        -DOMATH_BUILD_AS_SHARED_LIBRARY=${OMATH_SHARED}
        -DOMATH_BUILD_TESTS=OFF
        -DOMATH_BUILD_BENCHMARK=OFF
        -DOMATH_BUILD_EXAMPLES=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/omath" PACKAGE_NAME "omath")
kmpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
