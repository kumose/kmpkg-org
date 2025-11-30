if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/sentencepiece
    REF "v${VERSION}"
    SHA512 012850b63b2323e16acc5dacc0a494ad3f6375425ee86274f0946032e47c088a3b307758b99d752fcf54acf76c82d7d13d0c14bbf07aa9b612c4f1fbd30cf1cf
    HEAD_REF master
    PATCHES
        abseil.diff
        linkage.diff
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" SPM_ENABLE_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSPM_ENABLE_SHARED=${SPM_ENABLE_SHARED}
        -DSPM_ENABLE_TCMALLOC=OFF
        -DSPM_ABSL_PROVIDER=package
        -DSPM_PROTOBUF_PROVIDER=package
        -DPROTOBUF_LITE_LIBRARY=protobuf::libprotobuf-lite
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

kmpkg_copy_tools(TOOL_NAMES spm_decode spm_encode spm_export_vocab spm_normalize spm_train AUTO_CLEAN)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
