kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO SanderMertens/flecs
    REF "v${VERSION}"
    SHA512 ba7bef152d4b6f2e8e749f24525483532f5a9cf317296d3ae697790d632c4260cf828ab6db29bf69148c88a16710843dcfe362f96ec8c17738022ceffbbc6d79
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" FLECS_STATIC_LIBS)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" FLECS_SHARED_LIBS)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DFLECS_STATIC=${FLECS_STATIC_LIBS}
        -DFLECS_SHARED=${FLECS_SHARED_LIBS}
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

if(FLECS_STATIC_LIBS)
    kmpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/${PORT}/bake_config.h"
        "#ifndef flecs_STATIC"
        "#if 0 // #ifndef flecs_STATIC"
    )
endif()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
