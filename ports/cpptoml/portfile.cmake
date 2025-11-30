kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO skystrife/cpptoml
    REF "v${VERSION}"
    SHA512 14edce576514d53a7e13562d7f8d2b66ea2b95f44038396c0e26232ec81783042ebecec31ee272a99afef96d5c8582a8e81ea5167a787844b98de6ee6f545cc5
    HEAD_REF master
)

if(NOT KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_MINGW)
    list(APPEND OPTIONS -DENABLE_LIBCXX=OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${OPTIONS}
        -DCPPTOML_BUILD_EXAMPLES=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
