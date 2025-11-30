# header-only library
set(KMPKG_BUILD_TYPE release)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO adamstark/AudioFile
    REF "${VERSION}"
    SHA512 16a6879e8d91612980c8c2e86995de876a0868e051a47e4eaae7c8dea67327e008463b93e2536368e0f169329b7626b380d74eb369bef526dbc50a793f8cab92
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME AudioFile CONFIG_PATH lib/cmake/AudioFile)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
