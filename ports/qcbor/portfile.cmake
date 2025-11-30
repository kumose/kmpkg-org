# No DLL export(yet)
if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO laurencelundblade/QCBOR
    REF v${VERSION}
    SHA512 cae2f9ed6554744733bed03e751179eee36988918b1f3fd42fe833650613b4ec06e260bb4a9e9663c8498b7b6dbb1369e7d5fd0c900c4767070ea3d94d4ddab7
    HEAD_REF master
    PATCHES
        install.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_QCBOR_TEST=OFF
)

kmpkg_cmake_install()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
