kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/SPIRV-Cross
    REF vulkan-sdk-${VERSION}
    SHA512 7b3c68fb9c2a8ff665096d03291e0339b679f80cc190b626c94a072a515a702d1bf168a6e0c618795273570a8e5c29498c041b92beb860d931f000bc8c3bb72f
    HEAD_REF master
)

if(KMPKG_TARGET_IS_IOS)
    message(STATUS "Using iOS triplet. Executables won't be created...")
    set(BUILD_CLI OFF)
else()
    set(BUILD_CLI ON)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSPIRV_CROSS_EXCEPTIONS_TO_ASSERTIONS=OFF
        -DSPIRV_CROSS_CLI=${BUILD_CLI}
        -DSPIRV_CROSS_SKIP_INSTALL=OFF
        -DSPIRV_CROSS_ENABLE_C_API=ON
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

foreach(COMPONENT core c cpp glsl hlsl msl reflect util)
    kmpkg_cmake_config_fixup(CONFIG_PATH share/spirv_cross_${COMPONENT}/cmake PACKAGE_NAME spirv_cross_${COMPONENT})
endforeach()

if(BUILD_CLI)
    kmpkg_copy_tools(TOOL_NAMES spirv-cross AUTO_CLEAN)
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
