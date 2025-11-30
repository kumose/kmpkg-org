kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO maxmind/libmaxminddb
    REF "${VERSION}"
    SHA512 b5fe1eeffca697a7163fd3e66ae489eb144f5c35e601fcd29b37ec7996f7a485da6cd06431e452050731e09e889e96bc58e32b06c40fbef30f7e79781e492d85
    HEAD_REF main
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DCMAKE_SHARED_LIBRARY_PREFIX=lib
        -DCMAKE_STATIC_LIBRARY_PREFIX=lib
    OPTIONS_DEBUG
        -DCMAKE_DEBUG_POSTFIX=d
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/maxminddb PACKAGE_NAME maxminddb)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
