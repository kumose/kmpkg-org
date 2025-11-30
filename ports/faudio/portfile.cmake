kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO FNA-XNA/faudio
    REF "${VERSION}"
    SHA512 f5acd68969e918a70ca59e2f9ef9f1c0c528a07d10537525c440247ccda0d11af7e079a815a17352f35e28c11abb33b6a926db44e87eeaa1f6910c8f0dee9ad4
    HEAD_REF master
)

set(options "")
if(KMPKG_TARGET_IS_WINDOWS)
    list(APPEND options -DPLATFORM_WIN32=TRUE)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/FAudio)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(
    COMMENT "FAudio is licensed under the Zlib license."
    FILE_LIST
       "${SOURCE_PATH}/LICENSE"
)
