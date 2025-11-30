kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ros/urdfdom
    REF ${VERSION}
    SHA512 6386954bc7883e82d9db7c785ae074b47ca31efb7cc2686101e7813768824bed5b46a774a1296453c39ff76673a9dc77305bb2ac96b86ecf93fab22062ef2258
    HEAD_REF master
    PATCHES
        0001_use_math_defines.patch
        0005-fix-config-and-install.patch
        0006-pc_file_for_windows.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_copy_tools(TOOL_NAMES check_urdf urdf_mem_test urdf_to_graphiz urdf_to_graphviz AUTO_CLEAN)

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_cmake_config_fixup(CONFIG_PATH CMake)
else()
    kmpkg_cmake_config_fixup(CONFIG_PATH lib/urdfdom/cmake)
    # Empty folders
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/urdfdom")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/urdfdom")
endif()

if(NOT KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_MINGW)
    kmpkg_fixup_pkgconfig()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
