# kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY ONLY_DYNAMIC_CRT)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO leadedge/Spout2
    REF 62362774c96547d63b502d7efd5cfbf138eb7570 #v2.007.010
    SHA512 89d0dcec719c068e27c2f55605e4b45b32fe3a5e097c821b0aa45f4ee9284e63830bd741ac7bb1bff917190d9a51daa36b452580fc673c05767b7bfcbc9a494f
    HEAD_REF master
    PATCHES
        fix-include-path.patch
        fix-dx-keyed.patch
)

if(KMPKG_CRT_LINKAGE STREQUAL "static")
    list(APPEND OPTIONS -DSPOUT_BUILD_CMT=ON)
else()
    list(APPEND OPTIONS -DSPOUT_BUILD_CMT=OFF)
endif()

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        dx              SPOUT_BUILD_SPOUTDX
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSKIP_INSTALL_ALL=OFF
        ${FEATURE_OPTIONS}
        ${OPTIONS}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

# Handle copyright & usage
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

# remove unneeded files
file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
