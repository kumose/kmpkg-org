kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO arun11299/cpp-subprocess
    REF "v${VERSION}"
    SHA512 9901e97003276255fa4b7d97c9d1cc17f9c3a5b29a108ad3c4ed10c9794fb379a568ba587858a556630df2387cffd288e83fafeceae327aa7928635ba3121a49
    HEAD_REF master
    PATCHES
        fix-cmake-config-name.patch
        find-threads.patch
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSUBPROCESS_TESTS=OFF
        -DSUBPROCESS_INSTALL=ON
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME subprocess CONFIG_PATH lib/cmake/subprocess)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.MIT")
