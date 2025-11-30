kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO brechtsanders/xlsxio
    REF "${VERSION}"
    SHA512 6d22aa23290da84fbbf9ed5fbfbc3203b0171b58de14e94283cdd240c65f7f2b0b5b9f7f044d0b0a5d925f645cac305718b338b806004d8f844a525292972d28
    HEAD_REF master
    PATCHES
        fix-dependencies.patch
)

file(REMOVE "${SOURCE_PATH}/CMake/FindMinizip.cmake")

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_POLICY_DEFAULT_CMP0012=NEW
        -DBUILD_SHARED=${BUILD_SHARED}
        -DBUILD_STATIC=${BUILD_STATIC}
        -DWITH_WIDE=OFF
        -DBUILD_DOCUMENTATION=OFF
        -DBUILD_EXAMPLES=OFF
        -DBUILD_PC_FILES=OFF
        -DBUILD_TOOLS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup(CONFIG_PATH cmake)
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
