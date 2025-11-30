kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eProsima/Fast-CDR
    REF "v${VERSION}"
    SHA512 49ffa82bca0db4968ba2baecbf46c020ac1b072226486678cfe26ab7c023ab6cbcb1b48c48d9ac2e7254ef6ce0c61f717c3cbbc5f546a13d8dff299ce382580c
    HEAD_REF master
    PATCHES
        pdb-file.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH})

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/fastcdr)

kmpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/lib/fastcdr ${CURRENT_PACKAGES_DIR}/debug/lib/fastcdr)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/fastcdr/eProsima_auto_link.h" "(defined(_DLL) || defined(_RTLDLL)) && defined(EPROSIMA_DYN_LINK)" "1")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/fastcdr/fastcdr_dll.h" "defined(FASTCDR_DYN_LINK)" "1")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
