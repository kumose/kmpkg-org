kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 3MFConsortium/lib3mf
    REF "v${VERSION}"
    SHA512 91d3928315bd5d1a8553284505d28c7d839a3cbd8b07a87bca5a21087fffa8ba7a1738ed14313212815a09e33f7a82318f7b069f1bbe40456b57ec528379ab4b
    PATCHES
    lib3mf_kmpkg.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS 
        -DUSE_INCLUDED_ZLIB=OFF
        -DUSE_INCLUDED_LIBZIP=OFF
        -DUSE_INCLUDED_SSL=OFF
        -DBUILD_FOR_CODECOVERAGE=OFF
        -DLIB3MF_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/lib3mf)
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
