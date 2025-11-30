kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ctabin/libzippp
    REF 7e65f6cd173da8f20393d331ceb697482b206edf #v7.1-1.10.1 with CXX std version c++11
    SHA512 0076e39f6c1375d61e70dedc5132c48a8191534f2e6aeb042fe0f80c2aa068112e709446b29f84e513bf40ad532816c07155c2bc8ff86114e9c2f45b3f514fc0
    HEAD_REF master
)

kmpkg_check_features( 
        OUT_FEATURE_OPTIONS FEATURE_OPTIONS
        FEATURES    
        encryption LIBZIPPP_ENABLE_ENCRYPTION)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DLIBZIPPP_BUILD_TESTS=OFF
    OPTIONS_DEBUG
        -DLIBZIPPP_INSTALL_HEADERS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_cmake_config_fixup(CONFIG_PATH "cmake/libzippp")
else()
    kmpkg_cmake_config_fixup(CONFIG_PATH "share/libzippp")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENCE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
