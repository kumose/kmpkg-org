kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/draco
    REF "${VERSION}"
    SHA512 8b444744cdf12fb9d276916eb2ff0735cd1a6497b65b88813ec457fe2169db987db62e3db253a7d0f3ae7d45ae6502e8a9f8c0b81abde73e07b3bec69f9dc170
    HEAD_REF master
    PATCHES
        fix-compile-error-uwp.patch
        fix-uwperror.patch
        fix-pkgconfig.patch
        disable-symlinks.patch
        install-linkage.diff
)

if(KMPKG_TARGET_IS_EMSCRIPTEN)
    set(ENV{EMSCRIPTEN} "${EMSCRIPTEN_ROOT}")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DPYTHON_EXECUTABLE=: # unused with DRACO_JS_GLUE off
        -DDRACO_JS_GLUE=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/draco)
kmpkg_fixup_pkgconfig()

# Install tools and plugins
if(NOT KMPKG_TARGET_IS_EMSCRIPTEN)
    kmpkg_copy_tools(TOOL_NAMES draco_encoder draco_decoder AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
