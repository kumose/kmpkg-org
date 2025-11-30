kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO spotify/annoy
    REF "v${VERSION}"
    SHA512 a8ec84440019a29dc2939b193ca1f894aad6bc95d2814a7f0296fbd5faf7bdb69072514db496a445993b20182133a8e4e6e774c75f17d3057d146e98bdde28ce
    HEAD_REF master
)

set(KMPKG_BUILD_TYPE "release") # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/annoy)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
