kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO bfgroup/Lyra
    REF "${VERSION}"
    SHA512 3554fed9599c8ad8d594f8061f778093526598887f317843eb025ed773d89fbb15dd7bed0059513ac38e89a17ae91b063f5dca64fac4e71df5446fe0f302f413
    HEAD_REF release
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(
    PACKAGE_NAME lyra
    CONFIG_PATH share/lyra/cmake
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
