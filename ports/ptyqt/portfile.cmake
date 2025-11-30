kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kafeg/ptyqt
    REF "${VERSION}"
    SHA512 fe24dcbc3f7f94af2af5b47e78090ef1557626921012e9b5ec44334ea10873374df17e43c76b34e1693f26f40b0d20020c11bc1369a565ccb6f49bfce054c7b9
    HEAD_REF master
)

if(KMPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(KMPKG_CXX_FLAGS "${KMPKG_CXX_FLAGS} -lrt")
    set(KMPKG_C_FLAGS "${KMPKG_C_FLAGS} -lrt")

    if(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        file(READ "${SOURCE_PATH}/core/CMakeLists.txt" filedata)
        string(REPLACE "-static-libstdc++" "-static-libstdc++ -lglib-2.0" filedata "${filedata}")
        file(WRITE "${SOURCE_PATH}/core/CMakeLists.txt" "${filedata}")
    else()
        file(READ "${SOURCE_PATH}/core/CMakeLists.txt" filedata)
        string(REPLACE "-static-libstdc++ -lglib-2.0" "-static-libstdc++" filedata "${filedata}")
        file(WRITE "${SOURCE_PATH}/core/CMakeLists.txt" "${filedata}")
    endif()
endif()

if (KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(BUILD_TYPE SHARED)
else()
    set(BUILD_TYPE STATIC)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DNO_BUILD_TESTS=1
        -DNO_BUILD_EXAMPLES=1
        -DBUILD_TYPE=${BUILD_TYPE}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
