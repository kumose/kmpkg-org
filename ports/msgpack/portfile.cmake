if (EXISTS ${CURRENT_INSTALLED_DIR}/include/msgpack/pack.h)
    message(FATAL_ERROR "Cannot install ${PORT} when rest-rpc is already installed, please remove rest-rpc using \"./kmpkg remove rest-rpc:${TARGET_TRIPLET}\"")
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO msgpack/msgpack-c
    REF cpp-${VERSION}
    SHA512 3b64605974b64384619c07a4895f8ceb56243046b5c941345594d70baf3ad7749573b83c5b20e83505204fc1905ddb0a7dde1c5109ef8a34b5c848d1bb073946
    HEAD_REF cpp_master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        boost MSGPACK_USE_BOOST
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMSGPACK_BUILD_EXAMPLES=OFF
        -DMSGPACK_BUILD_TESTS=OFF
        -DMSGPACK_BUILD_DOCS=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME msgpack-cxx CONFIG_PATH lib/cmake/msgpack-cxx)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
