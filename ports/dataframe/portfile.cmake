kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hosseinmoein/DataFrame
    REF "${VERSION}"
    SHA512 fa950dc2c2a6c001528e1c6d3ff6671cb7d929c47d3171773971d23e6866c5d83692b9f0791d1897c18710a839d42903eec4e8286d40cd8ae2db8503ebce2511
    HEAD_REF master
)
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DHMDF_TESTING:BOOL=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/DataFrame)

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License")
