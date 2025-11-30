kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO discordapp/discord-rpc
    REF "v${VERSION}"
    SHA512 ca981b833aff5f21fd629a704deadd8e3fb5423d959ddb75e381313f6462d984c567671b10c8f031905c08d85792ddbe2dddc402ba2613c42de9e80fc68d0d51
    HEAD_REF master
    PATCHES disable-downloading.patch
)

string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" STATIC_CRT)
file(REMOVE_RECURSE "${SOURCE_PATH}/thirdparty")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUSE_STATIC_CRT=${STATIC_CRT}
        -DBUILD_EXAMPLES=OFF
        "-DRAPIDJSON=${CURRENT_INSTALLED_DIR}"
)

if(EXISTS "${SOURCE_PATH}/thirdparty")
    message(FATAL_ERROR "The source directory should not be modified during the build.")
endif()

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

kmpkg_copy_pdbs()
