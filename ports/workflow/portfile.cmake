if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    kmpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sogou/workflow
        REF "v${VERSION}-win"
        SHA512 4d33904742c41b9cc5efb38a0950dd1f1ef5a0aacab1d3c1fda899244af5b63e734c74dcb5a231623518880b90fa1db5280bf03c4186e94d293fcd2ad6286929
        HEAD_REF windows
    )
else()
    kmpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sogou/workflow
        REF "v${VERSION}"
        SHA512 ea90fb1a9c289a76dfa02b077cb0d99ec27157747f1b73d4437a089560a2659baebd463e2e6f699fbd44ec01e59bcd4d4b2f4556377dd57834f02bde0aefdca3
        HEAD_REF master
    )
endif()

if(KMPKG_CRT_LINKAGE STREQUAL "static")
    set(CONFIGURE_OPTIONS "-DWORKFLOW_BUILD_STATIC_RUNTIME=ON")
else()
    set(CONFIGURE_OPTIONS "-DWORKFLOW_BUILD_STATIC_RUNTIME=OFF")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS ${CONFIGURE_OPTIONS}
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
