kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zyantific/zydis
    REF "v${VERSION}"
    SHA512 177e84fedb3449e29ffb6c0b02a92066ba1aa8fb624facad5593902b8e08cb8ae0b20ff38c16987989c8e414d7484d09dab7917c00a8fe54aa9bab4bc90e275d
    HEAD_REF master
    PATCHES
        zycore.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" ZYDIS_BUILD_SHARED_LIB)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools       ZYDIS_BUILD_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DZYAN_SYSTEM_ZYCORE=ON
        -DZYDIS_BUILD_SHARED_LIB=${ZYDIS_BUILD_SHARED_LIB}
        -DZYDIS_BUILD_DOXYGEN=OFF
        -DZYDIS_BUILD_EXAMPLES=OFF
        -DZYDIS_BUILD_TESTS=OFF
        ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DZYDIS_BUILD_TOOLS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/zydis)

if ("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES ZydisDisasm ZydisInfo AUTO_CLEAN)
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL static)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/Zydis/Defines.h" "defined(ZYDIS_STATIC_BUILD)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
