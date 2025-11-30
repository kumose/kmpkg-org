kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO facebook/proxygen
    REF "v${VERSION}"
    SHA512 7b122317ebd9d781df9568cfb991483e19ed2b8e2a76e5a12af7399e3a656b269e813784c65b490c6b45b9a0aa5658f4f0a5a64ed4fa5ade100b73fb3a9e6e8e
    HEAD_REF main
    PATCHES
        remove-register.patch
        folly-has-liburing.diff
        fix-dependency.patch
)

kmpkg_find_acquire_program(PYTHON3)

kmpkg_add_to_path(PREPEND "${CURRENT_HOST_INSTALLED_DIR}/tools/gperf")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DPROXYGEN_PYTHON=${PYTHON3}"
        -DKMPKG_LOCK_FIND_PACKAGE_gflags=ON
        -DCMAKE_INSTALL_DIR=share/proxygen
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup()

kmpkg_copy_tools(TOOL_NAMES hq proxygen_curl proxygen_echo proxygen_h3datagram_client proxygen_httperf2 proxygen_proxy proxygen_push proxygen_static AUTO_CLEAN)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
