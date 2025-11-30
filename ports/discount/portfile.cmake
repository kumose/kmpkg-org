# No dynamic link for MSVC
kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Orc/discount
    REF "v${VERSION}"
    SHA512 ab24722bb8513f64eed59bb2770276b91615033b494a0492a331f36c5fcd2e32b7a9f3bd7ef0bb74c107f1e0e955522c83ddba6c482fca7f18cf275334707c4d
    HEAD_REF master
    PATCHES
      generate-blocktags-command.patch
      disable-deprecated-warnings.patch
)

set(GENERATE_BLOCKTAGS ON)
if(KMPKG_TARGET_ARCHITECTURE MATCHES "arm" OR KMPKG_TARGET_ARCHITECTURE MATCHES "arm64" OR KMPKG_CMAKE_SYSTEM_NAME MATCHES "WindowsStore")
    set(GENERATE_BLOCKTAGS OFF)
endif()

if(NOT GENERATE_BLOCKTAGS)
    configure_file("${CURRENT_PORT_DIR}/blocktags" "${SOURCE_PATH}/blocktags" COPYONLY)
    message(STATUS "Copied blocktags")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/cmake"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DDISCOUNT_ONLY_LIBRARY=ON
        -DGENERATE_BLOCKTAGS=${GENERATE_BLOCKTAGS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/discount)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYRIGHT" DESTINATION "${CURRENT_PACKAGES_DIR}/share/discount" RENAME copyright)

