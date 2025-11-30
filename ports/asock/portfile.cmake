set(KMPKG_BUILD_TYPE release) # header-only

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jeremyko/ASockLib
    REF "${VERSION}"
    SHA512 6c05cd7796a7a2b788e304a7ecd419f64f9b80368f941e5730c68cb1e439058cac03ce06426c166da7c144b58174942834159cbd271cc2612e5c9cd210788411
    HEAD_REF master
)
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DJEREMYKO_ASOCK_BUILD_TESTS=OFF
        -DJEREMYKO_ASOCK_BUILD_SAMPLES=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "share/cmake/asock")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")
file(REMOVE "${CURRENT_PACKAGES_DIR}/share/asock/LICENSE" "${CURRENT_PACKAGES_DIR}/share/asock/README.md")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

