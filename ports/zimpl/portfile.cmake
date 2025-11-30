kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

# The latest version of ZIMPL is included in the SCIP Optimization Suite.
set(scipoptsuite_version 9.1.0)
kmpkg_download_distfile(ARCHIVE
    URLS "https://scipopt.org/download/release/scipoptsuite-${scipoptsuite_version}.tgz"
    SHA512 03c1c49dd5e4dbc5bfd4f07305937079773f6912c87b0ba86166fc02996928e8d23332137a944f16f2488a88dc12a4a2c6ebde216eb4532135ed282a182bfdaf
    FILENAME "scipoptsuite-${scipoptsuite_version}.tgz"
)
kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
        libm.diff
        msvc.diff
)

kmpkg_find_acquire_program(BISON)
kmpkg_find_acquire_program(FLEX)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/zimpl"
    OPTIONS
        -DBREW=false
        "-DBISON_EXECUTABLE=${BISON}"
        "-DFLEX_EXECUTABLE=${FLEX}"
        -DCMAKE_REQUIRE_FIND_PACKAGE_ZLIB=1
    MAYBE_UNUSED_VARIABLES
        BREW
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/zimpl)
kmpkg_copy_tools(TOOL_NAMES zimpl AUTO_CLEAN)

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/zimpl/zimpl-config.cmake" "../../../include" "../../include")
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/zimpl/mmlparse2.h" "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/zimpl/" "")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/zimpl/LICENSE")
