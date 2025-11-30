kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO maxbachmann/rapidfuzz-cpp
    REF "v${VERSION}"
    SHA512 51d3e38ca0ec2592ee5562208180bc11d6e4b4663405d3541768c060e6fef72cb35338a53c03e7411601123e42480b35749fb59530f52dfa99b5ed18d21aa5ec
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
