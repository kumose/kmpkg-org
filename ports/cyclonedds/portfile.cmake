kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eclipse-cyclonedds/cyclonedds
    REF "${VERSION}"
    SHA512 de63a7207c36ff1b185b1a108d697d37675078ac15c34a940429b619b048593056dd8c4c920fb708235b972f94536452973eb40a8e66da1d57cb9b9b03005f30
    HEAD_REF master
    PATCHES
        enable-security.patch
        idlc-generate.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "ddsperf"                   BUILD_DDSPERF
        "deadline-missed"           ENABLE_DEADLINE_MISSED
        "ipv6"                      ENABLE_IPV6
        "idlc"                      BUILD_IDLC
        "lifespan"                  ENABLE_LIFESPAN
        "security"                  ENABLE_SECURITY
        "shm"                       ENABLE_SHM
        "source-specific-multicast" ENABLE_SOURCE_SPECIFIC_MULTICAST
        "ssl"                       ENABLE_SSL
        "topic-discovery"           ENABLE_TOPIC_DISCOVERY
        "type-discovery"            ENABLE_TYPE_DISCOVERY
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/CycloneDDS")

if(BUILD_IDLC)
    kmpkg_copy_tools(TOOL_NAMES idlc AUTO_CLEAN)
endif()

if(BUILD_DDSPERF)
    kmpkg_copy_tools(TOOL_NAMES ddsperf AUTO_CLEAN)
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_fixup_pkgconfig()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
