kmpkg_from_sourceforge(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsmacker
    REF libsmacker-1.2
    FILENAME "libsmacker-1.2.0r43.tar.gz"
    SHA512 1785b000884a6f93b621c1503adef100ac9b8c6e7ed5ef4d85b9ea4819715c40f9af3d930490b33ca079f531103acc69de2a800756ed7678c820ff155f86aaeb
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/smacker.def" DESTINATION "${SOURCE_PATH}")

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools LIBSMACKER_BUILD_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS 
        ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DLIBSMACKER_BUILD_TOOLS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-libsmacker)
kmpkg_copy_pdbs()

file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/debug/include"
)

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES driver smk2avi AUTO_CLEAN)
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
