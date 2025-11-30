kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO webui-dev/webui
    REF "${VERSION}"
    SHA512 b82321195d0684c11380691ec07e359b348c7a73c649f3f55c45e2748051b7fdd17925bdc96dc32824eb8fde74bf54bb7d778ac5384c1bb47c7841586fe54033
    HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tls   WEBUI_USE_TLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-webui)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
