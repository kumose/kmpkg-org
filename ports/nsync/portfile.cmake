if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/nsync
    REF "${VERSION}"
    SHA512 fdcd61eb686ca6d6804d82837fcd33ddee54d6b2aeb7bc20cdff8c5bd2a75f87b724f72c7e835459a1a82ee8bed3d6da5e4c111b3bca22545c6e037f129839f2
    HEAD_REF master
    PATCHES
        fix-install.patch
        add-include-chrono.patch # https://github.com/google/nsync/pull/25
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DNSYNC_ENABLE_TESTS=OFF
)
kmpkg_cmake_build()
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nsync_cpp PACKAGE_NAME nsync_cpp DO_NOT_DELETE_PARENT_CONFIG_PATH)
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nsync)
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
