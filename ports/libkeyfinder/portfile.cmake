kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mixxxdj/libkeyfinder
    REF ${VERSION}
    SHA512 31d86715172b62dd72b122a8d480db4598731b87ca58522ad797116acfcbc53b8ecf8fe7eb2b129857b5044b27d32dda9e03927e0a27f8edcdc5d6ce607a76eb
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME KeyFinder CONFIG_PATH lib/cmake/KeyFinder)
kmpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/debug/share")
