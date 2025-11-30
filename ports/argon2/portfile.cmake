kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO P-H-C/phc-winner-argon2
    REF 20190702
    SHA512 0a4cb89e8e63399f7df069e2862ccd05308b7652bf4ab74372842f66bcc60776399e0eaf979a7b7e31436b5e6913fe5b0a6949549d8c82ebd06e0629b106e85f
    HEAD_REF master
    PATCHES
        visibility.patch
        visibility-for-tool.patch
        thread-header.patch
)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        hwopt   WITH_OPTIMIZATIONS
        tool    BUILD_TOOL
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DUPSTREAM_VER=${VERSION}
    OPTIONS_DEBUG
        -DBUILD_TOOL=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
file(COPY "${CMAKE_CURRENT_LIST_DIR}/unofficial-argon2-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-argon2")
kmpkg_cmake_config_fixup(CONFIG_PATH share/unofficial-argon2 PACKAGE_NAME unofficial-argon2)
# Migration path
file(COPY "${CMAKE_CURRENT_LIST_DIR}/unofficial-libargon2-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-libargon2")

if(BUILD_TOOL)
    kmpkg_copy_tools(TOOL_NAMES argon2 AUTO_CLEAN)
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/argon2.h" "defined(USING_ARGON2_DLL)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
