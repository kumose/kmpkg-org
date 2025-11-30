if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_download_distfile(
    ARCHIVE
    URLS "http://iausofa.org/2023_1011_C/sofa_c-${VERSION}.tar.gz"
    FILENAME "sofa_c-${VERSION}.tar.gz"
    SHA512 8e7d67f7ac7a285a96160c96d16b1921ccb7a9324b83280b1594efcbbd7eb78c4d41898c1e5acfa5081842e4aeee15a96572d21b466bfda7ef7582c58624d376
)

kmpkg_extract_source_archive(SOURCE_PATH ARCHIVE "${ARCHIVE}")

set(SOURCE_SUBDIR "${SOURCE_PATH}/${VERSION}/c")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_SUBDIR}")

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_SUBDIR}")

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME "unofficial-iausofa")

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${CMAKE_CURRENT_LIST_DIR}/LICENSE")
