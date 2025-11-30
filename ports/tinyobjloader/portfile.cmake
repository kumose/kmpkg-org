kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO syoyo/tinyobjloader
    REF "v${VERSION}"
    SHA512 724f3974e03c0bbb2255da051a42bec26a91e490414c36bd4bd5dd18a511ba821148e996f9fa4eba6c4b3638d331281a248c530389e2a8bf679b7e81bb09a89b
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        double TINYOBJLOADER_USE_DOUBLE
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_INSTALL_DOCDIR:STRING=share/tinyobjloader
        # FEATURES
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/tinyobjloader/cmake)

if("double" IN_LIST FEATURES)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/tiny_obj_loader.h" "#ifdef TINYOBJLOADER_USE_DOUBLE" "#if 1")
else()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/tiny_obj_loader.h" "#ifdef TINYOBJLOADER_USE_DOUBLE" "#if 0")
endif()
file(
    REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include
    ${CURRENT_PACKAGES_DIR}/debug/share
    ${CURRENT_PACKAGES_DIR}/lib/tinyobjloader
    ${CURRENT_PACKAGES_DIR}/debug/lib/tinyobjloader
)

kmpkg_copy_pdbs()

# Put the licence file where kmpkg expects it
file(RENAME ${CURRENT_PACKAGES_DIR}/share/tinyobjloader/LICENSE ${CURRENT_PACKAGES_DIR}/share/tinyobjloader/copyright)

kmpkg_fixup_pkgconfig()
