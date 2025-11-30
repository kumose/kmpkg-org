kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO fredemmott/magic_args
    REF "v${VERSION}"
    SHA512 ed89bf1d834ed5c053c436387604cbd27387cf014fc2de969bf557522fb47da8b6b599c9607694f9b99d5f829133683e524ae23ac909c9064e509e7b8b0056c2
    HEAD_REF master
)

set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME magic_args CONFIG_PATH lib/cmake/magic_args)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
