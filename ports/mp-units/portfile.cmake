if(KMPKG_TARGET_IS_LINUX)
    message("Note: `mp-units` requires Clang16+ or GCC11+")
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mpusz/mp-units
    REF "v${VERSION}"
    SHA512 7e3a897a0df438d43dc860febe813f84b671caa26195cea1e8df75769d418d5456852200b8f546107c97214e88e77015e044a95d0c45d4c19341288136e11fbc
    PATCHES
      config.patch
)


kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/src"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

# Handle copyright/readme/package files
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
file(INSTALL "${SOURCE_PATH}/README.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug"
                    "${CURRENT_PACKAGES_DIR}/lib") # Header only
