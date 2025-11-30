
set(VERSION 1.1.4)

kmpkg_download_distfile(ARCHIVE
    URLS "http://w3.impa.br/~diego/software/rply/rply-${VERSION}.tar.gz"
    FILENAME "rply-${VERSION}.tar.gz"
    SHA512 be389780b8ca74658433f271682d91e89709ced588c4012c152ccf4014557692a1afd37b1bd5e567cedf9c412d42721eb0412ff3331f38717e527bd5d29c27a7
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    SOURCE_BASE "${VERSION}"
    PATCHES
        fix-uninitialized-local-variable.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/rply.def" DESTINATION "${SOURCE_PATH}")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/rply-config.cmake.in" DESTINATION "${SOURCE_PATH}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
