# highfive should be updated together with hdf5

string(REPLACE "." "." hdf5_ref "hdf5_${VERSION}")
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO  HDFGroup/hdf5
    REF "${hdf5_ref}"
    SHA512 f3907abb530c4818cd9c0eb78b43073f3133260baa008ed52478e50e6bf9f1520365882acba21e0206e72c37c3e564d450def4edc3d2eef46275a41a2ad3f34b
    HEAD_REF develop
    PATCHES
        hdf5_config.patch
        pkgconfig.patch
)

set(ALLOW_UNSUPPORTED OFF)
if ("parallel" IN_LIST FEATURES AND "cpp" IN_LIST FEATURES)
    message(WARNING "Feature 'Parallel' and 'cpp' are mutually exclusive, enabling option ALLOW_UNSUPPORTED automatically to enable them both.")
    set(ALLOW_UNSUPPORTED ON)
endif()

if ("threadsafe" IN_LIST FEATURES AND
    ("parallel" IN_LIST FEATURES
     OR "fortran" IN_LIST FEATURES
     OR "cpp" IN_LIST FEATURES)
     )
    message(WARNING "Feture 'threadsafe' and other features are mutually exclusive, enabling feature ALLOW_UNSUPPORTED automatically to enable them both.")
    set(ALLOW_UNSUPPORTED ON)
endif()

if ("fortran" IN_LIST FEATURES)
    message(WARNING "Feature 'fortran' is not yet officially supported within KMPKG. Build will most likly fail if ninja 1.10 and a Fortran compiler are not available.")
endif()

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        parallel     HDF5_ENABLE_PARALLEL
        tools        HDF5_BUILD_TOOLS
        tools        HDF5_BUILD_HL_GIF_TOOLS
        cpp          HDF5_BUILD_CPP_LIB
        szip         HDF5_ENABLE_SZIP_SUPPORT
        szip         HDF5_ENABLE_SZIP_ENCODING
        zlib         HDF5_ENABLE_Z_LIB_SUPPORT
        fortran      HDF5_BUILD_FORTRAN
        threadsafe   HDF5_ENABLE_THREADSAFE
        utils        HDF5_BUILD_UTILS
        map          HDF5_ENABLE_MAP_API
)

if("tools" IN_LIST FEATURES AND KMPKG_CRT_LINKAGE STREQUAL "static")
    list(APPEND FEATURE_OPTIONS -DBUILD_STATIC_EXECS=ON)
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND FEATURE_OPTIONS -DONLY_SHARED_LIBS=ON)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_TESTING=OFF
        -DHDF5_ALLOW_EXTERNAL_SUPPORT=NO
        -DHDF5_BUILD_EXAMPLES=OFF
        -DHDF5_INSTALL_DATA_DIR=share/hdf5/data
        -DHDF5_INSTALL_CMAKE_DIR=share/hdf5
        -DHDF_PACKAGE_NAMESPACE:STRING=hdf5::
        -DHDF5_MSVC_NAMING_CONVENTION=OFF
        -DALLOW_UNSUPPORTED=${ALLOW_UNSUPPORTED}
    OPTIONS_RELEASE
        -DCMAKE_DEBUG_POSTFIX= # For lib name in pkgconfig files
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup()

set(debug_suffix debug)
if(KMPKG_TARGET_IS_WINDOWS)
    set(debug_suffix D)
endif()

kmpkg_fixup_pkgconfig()

file(GLOB pc_files "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/*.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/*.pc")
foreach(file IN LISTS pc_files)
    if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW AND KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        kmpkg_replace_string("${file}" " -lhdf5" " -llibhdf5" IGNORE_UNCHANGED)
    endif()
    if(KMPKG_TARGET_IS_WINDOWS)
        kmpkg_replace_string("${file}" "/msmpi.lib\"" "/msmpi\"" IGNORE_UNCHANGED)
    endif()
endforeach()

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/hdf5/hdf5-config.cmake"
    [[${HDF5_PACKAGE_NAME}_TOOLS_DIR "${PACKAGE_PREFIX_DIR}/bin"]]
    [[${HDF5_PACKAGE_NAME}_TOOLS_DIR "${PACKAGE_PREFIX_DIR}/tools/hdf5"]]
)
if("parallel" IN_LIST FEATURES AND NOT KMPKG_BUILD_TYPE)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/hdf5/hdf5-config.cmake"
        [[..HDF5_PACKAGE_NAME._MPI_C_LIBRARIES    "..KMPKG_IMPORT_PREFIX.(/lib/[^"]*)"]]
        [[${HDF5_PACKAGE_NAME}_MPI_C_LIBRARIES    optimized "${KMPKG_IMPORT_PREFIX}\1" debug "${KMPKG_IMPORT_PREFIX}/debug\1"]]
        REGEX
    )
endif()

set(HDF5_TOOLS "")
if("tools" IN_LIST FEATURES)
    list(APPEND HDF5_TOOLS h5copy h5diff h5dump h5ls h5stat gif2h5 h52gif h5clear h5debug
        h5format_convert h5jam h5unjam h5mkgrp h5repack h5repart h5watch h5import h5delete
	h5perf_serial
    )

    if("parallel" IN_LIST FEATURES)
        list(APPEND HDF5_TOOLS ph5diff)
    endif()


    if(NOT KMPKG_TARGET_IS_WINDOWS)
        list(APPEND HDF5_TOOLS h5cc h5hlcc)
        if("cpp" IN_LIST FEATURES)
            list(APPEND HDF5_TOOLS h5c++ h5hlc++)
        endif()
    endif()

    if("parallel" IN_LIST FEATURES)
        list(APPEND HDF5_TOOLS h5perf )
        if(NOT KMPKG_TARGET_IS_WINDOWS)
            list(APPEND HDF5_TOOLS h5pcc)
        endif()
    endif()
endif()

if ("utils" IN_LIST FEATURES)
    list(APPEND HDF5_TOOLS mirror_server mirror_server_stop)
endif()

if(HDF5_TOOLS)
    kmpkg_copy_tools(TOOL_NAMES ${HDF5_TOOLS} AUTO_CLEAN)
    foreach(tool h5cc h5pcc h5hlcc)
        if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/${PORT}/${tool}")
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/${tool}" "${CURRENT_INSTALLED_DIR}" "$(dirname \"$0\")/../.." IGNORE_UNCHANGED)
        endif()
    endforeach()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/h5fuse.sh")
      file(RENAME "${CURRENT_PACKAGES_DIR}/bin/h5fuse.sh" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/h5fuse.sh")
      file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/h5fuse.sh")
    endif()
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

# Clean up
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

configure_file("${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" "${CURRENT_PACKAGES_DIR}/share/${PORT}/kmpkg-cmake-wrapper.cmake" @ONLY)
if("parallel" IN_LIST FEATURES)
    file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-port-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/H5public.h" "#define H5public_H" "#define H5public_H\n#ifndef H5_BUILT_AS_DYNAMIC_LIB\n#define H5_BUILT_AS_DYNAMIC_LIB\n#endif\n")
endif()

file(RENAME "${CURRENT_PACKAGES_DIR}/share/${PORT}/data/COPYING" "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright")
