kmpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL https://jugit.fz-juelich.de
    REPO mlz/libcerf
    REF "v${VERSION}"
    SHA512 0e78a18c498705d5efa26e504932192c4d49485cc3f971235c86c4dc6ca7498063f33e188a55f4c939e25d0d2a2f215b22ef11d3776d80a4a7486ea62fad1d73
    PATCHES
        cxx-flags.diff
        fix-source.diff
        begin-end-decls.diff
        install-dirs.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCERF_CPP=ON
        -DLIB_MAN=OFF
        -DLIB_RUN=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cerf PACKAGE_NAME cerf)
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/cerf.h" "dllexport" "dllimport")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
