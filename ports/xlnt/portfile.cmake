# Download the xlnt source code
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xlnt-community/xlnt
    REF "v${VERSION}"
    SHA512 2d016416447b56c3902fc86c0441fd1d10cb86c3a542a2a38929e32f8f55470c33e4a3938f9c47b1a672ac4d6784a981c4738a61fd076622a2baa64dbc632810
    HEAD_REF master
    PATCHES
        fix-not-found-include.patch
        fix-configure-dependencies.patch
)

# Download the libstudxml dependencies and copy it to the third-party folder as expected by xlnt (outside kmpkg libstudxml is included as a git submodule)
kmpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH_LIBSTUDXML
    URL https://git.codesynthesis.com/libstudxml/libstudxml.git
    FETCH_REF v1.1.0-b.10+2
    REF c8015cb75d7d3b3c499ec86b84d099c4c1ab942b
    HEAD_REF master
)
file(COPY "${SOURCE_PATH_LIBSTUDXML}/" DESTINATION "${SOURCE_PATH}/third-party/libstudxml")

if(KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(STATIC OFF)
else()
    set(STATIC ON)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS -DTESTS=OFF -DSAMPLES=OFF -DBENCHMARKS=OFF -DSTATIC=${STATIC}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/xlnt)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/man")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()
