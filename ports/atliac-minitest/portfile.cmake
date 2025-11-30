kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Atliac/minitest
    REF "v${VERSION}"
    SHA512 bd39aa9d4f897f03f0f42b28ee7aabc0fbe5168d09009ebcb253ee3cb5f52ae1d81e9c6657aaa93fe8f67d20d9d92874432a06cadcb78f750681772bb3316d78
    HEAD_REF master
)

kmpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_TESTS=OFF
        -DMINITEST_PACKAGE_NAME=${PORT}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup()

configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage")

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
