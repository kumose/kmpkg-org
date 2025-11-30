kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO awslabs/aws-c-http
    REF "v${VERSION}"
    SHA512 a4c0bb1ab69c158b3ff6ca98bf9bd29400e2fb35a0d2cea3e3b7e8238580802d967b1a0d5127105bf4fc8aa74748f96dcd16131a9ed04c1a218d072f5ffbb5b3
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
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
