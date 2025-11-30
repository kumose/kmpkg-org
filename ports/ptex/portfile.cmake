kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wdas/ptex
    REF "v${VERSION}"
    SHA512 34fcaf1c4fe27cb4e66d66bb729137ef17ffeea2bc2d849f2f5f543b19acc250f425633142320ce797c2a086e04bc3e0870c94928ad45d94e34faee71af36890
    HEAD_REF master
    PATCHES
        fix-build.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIB)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIB)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        "-DPTEX_VER=v${VERSION}"
        -DPTEX_BUILD_SHARED_LIBS=${BUILD_SHARED_LIB}
        -DPTEX_BUILD_STATIC_LIBS=${BUILD_STATIC_LIB}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Ptex )
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/pkgconfig/ptex.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/ptex.pc")
if(NOT KMPKG_BUILD_TYPE)
  file(COPY "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/ptex.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/")
endif()
kmpkg_fixup_pkgconfig()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/pkgconfig")

kmpkg_copy_pdbs()

foreach(HEADER PtexHalf.h Ptexture.h)
    file(READ "${CURRENT_PACKAGES_DIR}/include/${HEADER}" PTEX_HEADER)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        string(REPLACE "ifndef PTEX_STATIC" "if 1" PTEX_HEADER "${PTEX_HEADER}")
    else()
        string(REPLACE "ifndef PTEX_STATIC" "if 0" PTEX_HEADER "${PTEX_HEADER}")
    endif()
    file(WRITE "${CURRENT_PACKAGES_DIR}/include/${HEADER}" "${PTEX_HEADER}")
endforeach()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
