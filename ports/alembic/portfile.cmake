kmpkg_buildpath_length_warning(37)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO alembic/alembic
    REF "${VERSION}"
    SHA512 0be292e9d75560891d38129eb2672c55475b29b33f265dd51396dfa7b530c92ac6dfdb05a4432ad1b6919e2c151068560eb04efb8d9b0c2a14f77ab489d3542c
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" ALEMBIC_SHARED_LIBS)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        hdf5 USE_HDF5
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DALEMBIC_SHARED_LIBS=${ALEMBIC_SHARED_LIBS}
        -DUSE_TESTS=OFF
        ${FEATURE_OPTIONS}
        -DALEMBIC_DEBUG_WARNINGS_AS_ERRORS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Alembic)

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

set(TOOLS abcdiff abcecho abcechobounds abcls abcstitcher abctree)
if(USE_HDF5)
    list(APPEND TOOLS abcconvert)
endif()

kmpkg_copy_tools(
    TOOL_NAMES ${TOOLS}
    AUTO_CLEAN
)
kmpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
