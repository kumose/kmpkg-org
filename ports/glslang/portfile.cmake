kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/glslang
    REF "${VERSION}"
    SHA512 8ba7e5f73746b221ff39387282e2d929d1142c60d1c79019f4c21c84b105fb59253e88f2f649a25e9bb7ab01094e455f002c7412aeea882548fac4a426eee809
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        opt ENABLE_OPT
        opt ALLOW_EXTERNAL_SPIRV_TOOLS
        tools ENABLE_GLSLANG_BINARIES
        rtti ENABLE_RTTI
)

if(ENABLE_GLSLANG_BINARIES)
    kmpkg_find_acquire_program(PYTHON3)
    get_filename_component(PYTHON_PATH ${PYTHON3} DIRECTORY)
    kmpkg_add_to_path("${PYTHON_PATH}")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXTERNAL=OFF
        -DGLSLANG_TESTS=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/glslang DO_NOT_DELETE_PARENT_CONFIG_PATH)
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/glslang-config.cmake"
    [[${PACKAGE_PREFIX_DIR}/lib/cmake/glslang/glslang-targets.cmake]]
    [[${CMAKE_CURRENT_LIST_DIR}/glslang-targets.cmake]]
)
file(REMOVE_RECURSE CONFIG_PATH "${CURRENT_PACKAGES_DIR}/lib/cmake" "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/glslang/Public/ShaderLang.h" "ifdef GLSLANG_IS_SHARED_LIBRARY" "if 1")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/glslang/Include/glslang_c_interface.h" "ifdef GLSLANG_IS_SHARED_LIBRARY" "if 1")
endif()

kmpkg_copy_pdbs()

if(ENABLE_GLSLANG_BINARIES)
    kmpkg_copy_tools(TOOL_NAMES glslang glslangValidator spirv-remap AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
