kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

string(REPLACE "-" "." BREAKPAD-VERSION "${VERSION}")
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/breakpad
    REF "v${BREAKPAD-VERSION}"
    SHA512 88c691983c6c92fd5321d729c8eec059914293de0e91fe1d429a6247f3b7299f32ec4938eccbbe2c95a9ca507db14d73a1c9798d5fce79a8b474c3c216f0951a
    HEAD_REF master
    PATCHES
        add-algorithm-1.patch
)

if(KMPKG_HOST_IS_LINUX OR KMPKG_TARGET_IS_LINUX OR KMPKG_TARGET_IS_ANDROID)
    kmpkg_from_git(
        OUT_SOURCE_PATH LSS_SOURCE_PATH
        URL https://chromium.googlesource.com/linux-syscall-support
        REF 9719c1e1e676814c456b55f5f070eabad6709d31
    )

    file(RENAME "${LSS_SOURCE_PATH}" "${SOURCE_PATH}/src/third_party/lss")
endif()

file(COPY
        "${CMAKE_CURRENT_LIST_DIR}/check_getcontext.cc"
        "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt"
        "${CMAKE_CURRENT_LIST_DIR}/unofficial-breakpadConfig.cmake"
    DESTINATION
    "${SOURCE_PATH}")

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "tools" INSTALL_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
    OPTIONS_RELEASE
        -DINSTALL_HEADERS=ON
)

kmpkg_cmake_install()
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/include/client/linux/data"
    "${CURRENT_PACKAGES_DIR}/include/client/linux/sender")

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(
        TOOL_NAMES
            microdump_stackwalk
            minidump_dump
            minidump_stackwalk
            core2md
            pid2md
            dump_syms
            minidump-2-core
            minidump_upload
            sym_upload
            core_handler
        AUTO_CLEAN)
endif()

kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-breakpad)

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
