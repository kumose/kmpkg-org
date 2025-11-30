kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zeux/meshoptimizer
    REF v${VERSION}
    SHA512 c00f2357c9c8d17804047c3c678f253bf13aa467b1dadc099a7958787e1725c501bd92a7837494d4831dd7c3428bbeb92353b70fd45ec71e88d753036318ab2f
    HEAD_REF master
    PATCHES
        dependencies.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        gltfpack  MESHOPT_BUILD_GLTFPACK
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIBS)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DMESHOPT_BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    OPTIONS_DEBUG
        -DMESHOPT_BUILD_GLTFPACK=OFF # tool
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/meshoptimizer)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if ("gltfpack" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES gltfpack AUTO_CLEAN)
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
