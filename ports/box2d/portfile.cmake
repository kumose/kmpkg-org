
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO erincatto/Box2D
    REF v${VERSION}
    SHA512 7367640e7f2ff395b8ca48766c71f57c96e08c298627c996eba76899a149ee28b0e3ecacfa4a224fdb5d160c7e25c6069bb8414fd1575787727d796097aa347b
    HEAD_REF main
    PATCHES
        libm.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBOX2D_SAMPLES=OFF
        -DBOX2D_BENCHMARKS=OFF
        -DBOX2D_DOCS=OFF
        -DBOX2D_PROFILE=OFF
        -DBOX2D_VALIDATE=OFF
        -DBOX2D_UNIT_TESTS=OFF
        -DBOX2D_COMPILE_WARNING_AS_ERROR=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/box2d)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/box2d/base.h" "defined( BOX2D_DLL )" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
