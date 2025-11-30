kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zeromq/zyre
    REF f2fd7252322b1b52be248b9ef96f8981de3b86ff
    SHA512 64502b4d1ca4296eb979a67f6058a80e931bb6db0cb29b94f6cb3285efe9a216e0014ea379a4018004f9354369bb98e5160474263568a825842e1e4d83a74225
    HEAD_REF master
)

configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/Config.cmake.in"
    "${SOURCE_PATH}/builds/cmake/Config.cmake.in"
    COPYONLY
)

foreach(_cmake_module Findczmq.cmake Findlibzmq.cmake)
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/${_cmake_module}"
        "${SOURCE_PATH}/${_cmake_module}"
        COPYONLY
    )
endforeach()

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" ZYRE_BUILD_SHARED)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" ZYRE_BUILD_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DZYRE_BUILD_SHARED=${ZYRE_BUILD_SHARED}
        -DZYRE_BUILD_STATIC=${ZYRE_BUILD_STATIC}
        -DENABLE_DRAFTS=OFF
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

if(EXISTS "${CURRENT_PACKAGES_DIR}/CMake")
    kmpkg_cmake_config_fixup(CONFIG_PATH CMake)
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/share/cmake/${PORT}")
    kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/${PORT})
endif()

file(COPY
    "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)

kmpkg_copy_tools(TOOL_NAMES zpinger AUTO_CLEAN)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(ZYRE_BUILD_STATIC)
    kmpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/zyre_library.h"
        "if defined ZYRE_STATIC"
        "if 1 //if defined ZYRE_STATIC"
    )
endif()

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

kmpkg_fixup_pkgconfig()
