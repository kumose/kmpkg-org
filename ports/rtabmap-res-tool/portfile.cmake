# Only the standalone tool
set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
set(KMPKG_BUILD_TYPE release)
kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO introlab/rtabmap
    REF ${VERSION}
    SHA512 9bcd0f359e0ee8060cf7088761544a3f7d38aadb37df820958f0811aa7b8edbfaf00f00d9472a8bf46261d4e5d868f9c10785263aaabaf374b6e5aa5237d70b0
    HEAD_REF master
)
file(COPY "${CURRENT_PORT_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DINSTALL_INCLUDE_DIR=include
        -DINSTALL_CMAKE_DIR=lib/cmake
        -DRTABMAP_VERSION=${VERSION}
)
kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/tools/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
