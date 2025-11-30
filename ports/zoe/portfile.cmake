kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO winsoft666/zoe
    HEAD_REF master
    REF "v${VERSION}"
    SHA512 af25c64e1bf28e0b2193e60eac30b3c90519786d13f3562c063dd524147dea0e398f6cb51973a266be90ce71c33c5aff2e6a83b17f2944a52b2aa53e4885f56a
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" ZOE_BUILD_SHARED_LIBS)
string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" ZOE_USE_STATIC_CRT)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DZOE_BUILD_SHARED_LIBS:BOOL=${ZOE_BUILD_SHARED_LIBS}
        -DZOE_USE_STATIC_CRT:BOOL=${ZOE_USE_STATIC_CRT}
        -DZOE_BUILD_TESTS:BOOL=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH share/zoe)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_copy_pdbs()
