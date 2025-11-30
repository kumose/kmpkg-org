kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO palacaze/sigslot
    REF "v${VERSION}"
    SHA512 fb08cec33cc126e0973179068ce2d1c45f36ab85339849c1a5cac746147f7cee244702fad5fe5f38fc8e73f0fce62f81b7642fba0ff3edfd8c22089bc9ddb1db
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -DSIGSLOT_COMPILE_EXAMPLES=OFF
      -DSIGSLOT_COMPILE_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME PalSigslot CONFIG_PATH lib/cmake/PalSigslot)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug"
    "${CURRENT_PACKAGES_DIR}/lib"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
