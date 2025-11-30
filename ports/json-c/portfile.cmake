kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO json-c/json-c
    REF "json-c-${VERSION}"

    SHA512 219d8c0da9a4016b74af238cc15dbec1f369a07de160bcc548d80279028e1b5d8d928deb13fec09c96a085fc0ecf10090e309cbe72d0081aca864433c4ae01db
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" JSON_BUILD_STATIC)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" JSON_BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_STATIC_LIBS=${JSON_BUILD_STATIC}
        -DBUILD_SHARED_LIBS=${JSON_BUILD_SHARED}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
