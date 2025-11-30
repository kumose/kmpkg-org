kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO awslabs/aws-crt-cpp
    REF "v${VERSION}"
    SHA512 14a4aef4f8d1084ec352bb252c7b1a84263288bdcb6e1fa18bf54f218e3900fb46ce1e4d231f467c2f3e8b7749ea3a30c83bc1393a3a6cb24b851a7b35f07a43
    PATCHES
        no-werror.patch
)

string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" STATIC_CRT)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        "-DSTATIC_CRT=${STATIC_CRT}"
        -DBUILD_DEPS=OFF
        "-DCMAKE_MODULE_PATH=${CURRENT_INSTALLED_DIR}/share/aws-c-common" # use extra cmake files
        -DBUILD_TESTING=FALSE
)

kmpkg_cmake_install()

string(REPLACE "dynamic" "shared" subdir "${KMPKG_LIBRARY_LINKAGE}")
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}/${subdir}" DO_NOT_DELETE_PARENT_CONFIG_PATH)
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/${PORT}-config.cmake" [[/${type}/]] "/")

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/lib/${PORT}"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/lib/${PORT}"
)

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
