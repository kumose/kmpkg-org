set(OATPP_VERSION "1.3.0")

kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oatpp/oatpp-websocket
    REF ${OATPP_VERSION}
    SHA512 e5d5f974da4fd95599352d04d18422c74b274be50a803cdb0b65674ebde8dfe8587c44ddb8b376ad866de06841935687be4294ac5954f33f0a087b009da23177
    HEAD_REF master
)

if (KMPKG_CRT_LINKAGE STREQUAL "static")
    set(OATPP_MSVC_LINK_STATIC_RUNTIME TRUE)
else()
    set(OATPP_MSVC_LINK_STATIC_RUNTIME FALSE)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DOATPP_BUILD_TESTS:BOOL=OFF"     
	"-DOATPP_MSVC_LINK_STATIC_RUNTIME=${OATPP_MSVC_LINK_STATIC_RUNTIME}"       
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME oatpp-websocket CONFIG_PATH lib/cmake/oatpp-websocket-${OATPP_VERSION})
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
