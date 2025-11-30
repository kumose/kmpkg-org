kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO rougier/freetype-gl
    REF "v${VERSION}"
    SHA512 0bdba3cf4e1460588a41b7f8e6d5ce46ecf437f2be605297a6a9676c3c2875fbc5cd3c4c36ab8902bb5827a1c1749c0e27cda36b98d1fef32576099ab4ed7e21
    HEAD_REF master
    PATCHES
        0001-Link-to-dependencies-also-for-static-build.patch
        0002-Remove-duplicate-installs.patch
        0003-Add-exports.patch
        0004-Change-install-dir-for-pkgconfig.patch
        0005-add-version.patch
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "glew" freetype-gl_WITH_GLEW
        "glad" freetype-gl_WITH_GLAD
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dfreetype-gl_BUILD_APIDOC=OFF
        -Dfreetype-gl_BUILD_DEMOS=OFF
        -Dfreetype-gl_BUILD_TESTS=OFF
        -Dfreetype-gl_BUILD_MAKEFONT=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
