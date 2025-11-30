kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO beltoforion/muparser
    REF "v${VERSION}"
    SHA512 48610dd112b5c8e1ea7615e29c9f9ca185091392b651794de039c14edfad4c62a6ae1d087393fdfd8d03a99f94a6e71275b86ddc8027234d322030bc7c25223e 
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        openmp    ENABLE_OPENMP
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        -DENABLE_SAMPLES=OFF
        -DENABLE_WIDE_CHAR=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/muparser")
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/muParserFixes.h" "#ifndef MUPARSER_STATIC" "#if 0")
else()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/muParserFixes.h" "#ifndef MUPARSER_STATIC" "#if 1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
