set(KMPKG_BUILD_TYPE release) # header-only
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kenba/via-httplib
    REF ${VERSION}
    SHA512 3a36d251b6dfe9ad40d798761169a70877c6d12a94ea2799670d701a4449e2fe15558bc9f50fa46e17e3f2a53b91eb233254efd5000eeece07890e1a804f301d
    HEAD_REF master    
)

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME ViaHttpLib CONFIG_PATH lib/cmake/ViaHttpLib)

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/ViaHttpLib/ViaHttpLibConfig.cmake"
"find_dependency(Boost 1.51)"
[[find_dependency(Boost COMPONENTS system)]])

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE_1_0.txt")
