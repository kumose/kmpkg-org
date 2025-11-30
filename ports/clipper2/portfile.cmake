if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO AngusJohnson/Clipper2
    REF "Clipper2_${VERSION}"
    SHA512 39153f35630ddc455ad4955a8b9b35f05bf3fad2a33c6e7232300b674a5172794a57c7bd18f96dd0a90d4607a44ecb32c92b0cacc7060d840d568032efaddf19
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/CPP"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DCLIPPER2_EXAMPLES=OFF
        -DCLIPPER2_TESTS=OFF
        -DCLIPPER2_UTILS=ON
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
