string(REGEX REPLACE "^([0-9]+)[.]([1-9])\$" "\\1.0\\2" MEDIAINFO_VERSION "${VERSION}")
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MediaArea/MediaInfoLib
    REF "v${MEDIAINFO_VERSION}"
    SHA512 897d319a4ab2e4c05711b3e28d19316a76af9d7981527f4f92ec471b9e8a7336cf78857d03af956a4c5b1fc35725750cedb56713d70a3e67019b4dc7248ba534
    HEAD_REF master
    PATCHES
        dependencies.diff
)

kmpkg_find_acquire_program(PKGCONFIG)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Project/CMake"
    OPTIONS
        -DBUILD_ZENLIB=0
        -DBUILD_ZLIB=0
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
        -DCMAKE_REQUIRE_FIND_PACKAGE_PkgConfig=1
        -DCMAKE_REQUIRE_FIND_PACKAGE_TinyXML=1
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME mediainfolib)
kmpkg_fixup_pkgconfig()
if(NOT KMPKG_BUILD_TYPE AND KMPKG_TARGET_IS_WINDOWS)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libmediainfo.pc" " -lmediainfo" " -lmediainfod")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
