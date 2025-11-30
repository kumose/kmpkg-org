kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO knik0/faad2
    REF "${VERSION}"
    SHA512 b8f17680610b2f47344ea52b54412a02810a85eaf9d4c91b97ca09b2c6415c62d4af1b0771bfcacb9dfee400ed34504c0bd3c28369921c0392b3809e7de46ec5
    HEAD_REF master
    PATCHES
        fix-install.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_copy_tools(TOOL_NAMES faad_cli AUTO_CLEAN)
else()
    kmpkg_copy_tools(TOOL_NAMES faad AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
