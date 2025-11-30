kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO rollbear/trompeloeil
    REF v${VERSION}
    SHA512 d6ff22843ac3541eb68bb2a97f5eafc39495704cd13875658aa0dc30a68ddbcc2bcec75848e5529b4bf80f5cc0ad52fb4330e135933c4a47d43d3eed1b3587de
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/trompeloeil)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_PACKAGES_DIR}/lib")

if(NOT EXISTS "${CURRENT_PACKAGES_DIR}/include/trompeloeil.hpp")
    message(FATAL_ERROR "Main includes have moved. Please update the forwarder.")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE_1_0.txt")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")
