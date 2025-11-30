kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mcuee/libusb-win32
    REF "release_${VERSION}"
    SHA512 a3dd4f65e21c26892a21342b990f40a9628759a58e76f8c65131633f279ff80a09b282eb247f282af2310f8a46d545e35b435992983ef8f3eada623ff0747e76
    HEAD_REF master
)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}/libusb")

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}/libusb")
kmpkg_cmake_install()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/libusb/COPYING_LGPL.txt")
