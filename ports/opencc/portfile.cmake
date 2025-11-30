kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO BYVoid/OpenCC
    REF "ver.${VERSION}"
    SHA512 713cf00931d7616994eb455eef3bc893096b5cd6d42b346aa1130591752d9612891ea3ed035bd7bd4ec7df1c90425e86375f5b3337fac11663c656c79a8f33e9
    HEAD_REF master
    PATCHES 
        fix-dependencies.patch
        # marisa-trie/0.3.0 requires C++17, so we need to enable it
        enable-cpp17.patch
)

kmpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
kmpkg_add_to_path("${PYTHON3_DIR}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_DOCUMENTATION=OFF
        -DENABLE_GTEST=OFF
        -DUSE_SYSTEM_RAPIDJSON=ON
        -DUSE_SYSTEM_TCLAP=ON
        -DUSE_SYSTEM_DARTS=ON
        -DUSE_SYSTEM_MARISA=ON
        -DPKG_CONFIG_EXECUTABLE=${CURRENT_HOST_INSTALLED_DIR}/tools/pkgconf/pkgconf
)

kmpkg_cmake_install(
    DISABLE_PARALLEL
)

kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/opencc)

kmpkg_fixup_pkgconfig()

set(tool_names "opencc" "opencc_dict" "opencc_phrase_extract")
if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES ${tool_names} AUTO_CLEAN)
endif()

foreach(opencc_tool IN LISTS tool_names)
    file(REMOVE
        "${CURRENT_PACKAGES_DIR}/bin/${opencc_tool}${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
        "${CURRENT_PACKAGES_DIR}/debug/bin/${opencc_tool}${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
    )
endforeach()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT KMPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
