if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO stxxl/stxxl
    REF b9e44f0ecba7d7111fbb33f3330c3e53f2b75236
    SHA512 800a8fb95b52b21256cecb848f95645c54851f4dc070e0cd64fb5009f7663c0c962a24ca3f246e54d6d45e81a5c734309268d7ea6f0b0987336a50a3dcb99616
    HEAD_REF master
    PATCHES
        # This patch can be removed when stxxl/stxxl/#95 is accepted
        fix-include-dir.patch
        0001-fix-visual-studio.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIBS)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DINSTALL_CMAKE_DIR:STRING=share/${PORT}
        -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_EXTRAS=OFF
        -DUSE_BOOST=OFF
        -DTRY_COMPILE_HEADERS=OFF
        -DUSE_STD_THREADS=ON
        -DNO_CXX11=OFF
        -DUSE_VALGRIND=OFF
        -DUSE_MALLOC_COUNT=OFF
        -DUSE_GCOV=OFF
        -DUSE_TPIE=OFF
    OPTIONS_DEBUG
        -DSTXXL_DEBUG_ASSERTIONS=ON
    OPTIONS_RELEASE
        -DSTXXL_DEBUG_ASSERTIONS=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup()

kmpkg_copy_tools(TOOL_NAMES stxxl_tool AUTO_CLEAN)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE_1_0.txt")
