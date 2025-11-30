if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.com
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eidheim/tiny-process-library
    REF v2.0.4
    SHA512 bbdd268361159b7c64cb60f29afa780ee5e57fa696f0683a55cb9824ec5985c8229a9a8217d2b9ecdd194b9a3acbbd75a1a821392361fbc85b1f6841f40c95db
    HEAD_REF master
    PATCHES
        disable-examples.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(
    CONFIG_PATH lib/cmake/tiny-process-library
)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
