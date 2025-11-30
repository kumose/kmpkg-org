if(KMPKG_TARGET_IS_LINUX)
    message(WARNING "Building ${PORT} requires a C++20 compliant compiler. GCC 12 and Clang 15 are known to work.")
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ada-url/ada
    REF "v${VERSION}"
    SHA512 728bf278fcac51a8ffdf5571cb486e789cd49511674c61e354c802bbfaeea64598fb22cd28ef4b02eacdd42c1c3437f40666ca8dba8097e0ecebbae1095de77f
    HEAD_REF main
    PATCHES
        no-cpm.patch
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools ADA_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DADA_BENCHMARKS=OFF
        -DADA_TESTING=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Python3=ON
        ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DADA_TOOLS=OFF
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(PACKAGE_NAME ada CONFIG_PATH "lib/cmake/ada")
kmpkg_fixup_pkgconfig()

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES adaparse AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE-APACHE" "${SOURCE_PATH}/LICENSE-MIT")
