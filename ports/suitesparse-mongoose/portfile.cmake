kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DrTimothyAldenDavis/SuiteSparse
    REF v7.8.3
    SHA512 fc0fd0aaf55a6712a3b8ca23bf7536a31d52033e090370ebbf291f05d0e073c7dcfd991a80b037f54663f524804582b87af86522c2e4435091527f0d3c189244
    HEAD_REF dev
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIBS)
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Mongoose"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
        -DSUITESPARSE_USE_CUDA=OFF
        -DSUITESPARSE_USE_STRICT=ON
        -DSUITESPARSE_USE_FORTRAN=OFF
        -DSUITESPARSE_DEMOS=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Python=ON  # Only used for tests
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(
    PACKAGE_NAME SuiteSparse_Mongoose
    CONFIG_PATH lib/cmake/SuiteSparse_Mongoose
)
kmpkg_fixup_pkgconfig()

kmpkg_copy_tools(TOOL_NAMES suitesparse_mongoose AUTO_CLEAN)
if (NOT "tools" IN_LIST FEATURES)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/tools")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/Mongoose/Doc/License.txt")
