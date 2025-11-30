kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO emil-e/rapidcheck
    REF ff6af6fc683159deb51c543b065eba14dfcf329b
    SHA512 79f1e869a3c55f62d3609cc4b3a56977f720c3eacf5e1792aa3a9bd5ab90aa077371bc0902d6c31503885f9ebcc633ed242ae6995866cb46fd12afdf425500e3
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DRC_INSTALL_ALL_EXTRAS=ON
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}/cmake")
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
