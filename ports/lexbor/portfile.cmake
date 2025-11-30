kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lexbor/lexbor
    REF v${VERSION}
    SHA512 5fb5c0f31b873ba669b784f914cf4e688d80e5fdbe06797add19334dcf54a9ffd76923f38600913df6bdd9a40475a27368a09a847515c7929353c25ace5048d4
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        perf  LEXBOR_WITH_PERF
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    ${FEATURE_OPTIONS}
    -DLEXBOR_BUILD_SHARED=${BUILD_SHARED}
    -DLEXBOR_BUILD_STATIC=${BUILD_STATIC}
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/include/lexbor/html/tree/insertion_mode"
    "${CURRENT_PACKAGES_DIR}/debug/include/lexbor/html/tree/insertion_mode"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
