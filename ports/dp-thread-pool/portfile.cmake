set(KMPKG_BUILD_TYPE release)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DeveloperPaul123/thread-pool
    REF ${VERSION}
    SHA512 c2a75117f7def0dacc2679f8eb70835acfba58d1aba7beec9bf0a29cdb23883222294dc4b04b77e323f8ecb8623b70d728bee46bf2c5a4fd6711a749c9709981
    HEAD_REF master
    PATCHES
        include.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DTP_BUILD_TESTS=OFF
        -DTP_BUILD_EXAMPLES=OFF
        -DTP_BUILD_BENCHMARKS=OFF
        -DTP_CXX_STANDARD=20
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(
    PACKAGE_NAME thread-pool
    CONFIG_PATH lib/cmake/thread-pool-${VERSION}
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
