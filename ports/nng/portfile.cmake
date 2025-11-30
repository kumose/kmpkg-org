kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nanomsg/nng
    REF "v${VERSION}"
    SHA512 cceedb16ecc3849f49b76a2ebfee4ba46a6d22b429aa9a5a94354c92aa643c5dcffd325f854ecba8ebe341c514f8288576a7be392f3a03a69152873fdd277fe3
    HEAD_REF master
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        mbedtls NNG_ENABLE_TLS
        tools NNG_ENABLE_NNGCAT
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DNNG_TESTS=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nng)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_replace_string(
    "${CURRENT_PACKAGES_DIR}/include/nng/nng.h"
    "defined(NNG_SHARED_LIB)"
    "0 /* defined(NNG_SHARED_LIB) */"
)

if(KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    kmpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/nng/nng.h"
        "!defined(NNG_STATIC_LIB)"
        "1 /* !defined(NNG_STATIC_LIB) */"
    )
else()
    kmpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/nng/nng.h"
        "!defined(NNG_STATIC_LIB)"
        "0 /* !defined(NNG_STATIC_LIB) */"
    )
endif()

if ("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES nngcat AUTO_CLEAN)
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")

kmpkg_copy_pdbs()
