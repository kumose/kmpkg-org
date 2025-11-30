kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Ryan-rsm-McKenzie/binary_io
    REF 2.0.6
    SHA512 055290ee81e93aa8a8cda567eea848c76a830d78afb1c40bc3ba0e23b41bf80364fc8621ddaf8d48678acc4b5b7fd1ba2075e2bd23995655131954f580bdd4ae
    HEAD_REF main
)

if(KMPKG_TARGET_IS_LINUX)
    message(WARNING "Build ${PORT} requires at least gcc 10.")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(
    PACKAGE_NAME binary_io
    CONFIG_PATH "lib/cmake/binary_io"
)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
