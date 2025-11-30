kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_sourceforge(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO polyclipping
    FILENAME "clipper_ver6.4.2.zip"
    NO_REMOVE_ONE_LEVEL
    SHA512 ffc88818c44a38aa278d5010db6cfd505796f39664919f1e48c7fa9267563f62135868993e88f7246dcd688241d1172878e4a008a390648acb99738452e3e5dd
    PATCHES
        fix_targets.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/cpp"
)


kmpkg_cmake_install()
kmpkg_cmake_config_fixup()

if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "debug")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/share/pkgconfig" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig")
endif()
if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "release")
    file(RENAME "${CURRENT_PACKAGES_DIR}/share/pkgconfig" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")
endif()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/FindCLIPPER.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/clipper")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/clipper")

file(INSTALL "${SOURCE_PATH}/License.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

kmpkg_fixup_pkgconfig()
