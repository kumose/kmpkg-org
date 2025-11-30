# FLTK has many improperly shared global variables that get duplicated into every DLL
kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO fltk/fltk
    REF "release-${VERSION}"
    SHA512 b18ff6322349af4416a37d28c4f42ebe355260786ed42bdd54dcc20dc92db1a38a8db74e6d637fdff8f320bdd51e2515c0fa939d30679c5f22ea99fb32c97204
    PATCHES
        dependencies.patch
        config-path.patch
        include.patch
        fix-system-link.patch
        math-h-polyfill.patch
)
file(REMOVE_RECURSE
    "${SOURCE_PATH}/jpeg"
    "${SOURCE_PATH}/png"
    "${SOURCE_PATH}/zlib"
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        opengl  OPTION_USE_GL
)

set(fluid_path_param "")
if(KMPKG_CROSSCOMPILING)
    set(fluid_path_param "-DFLUID_PATH=${CURRENT_HOST_INSTALLED_DIR}/tools/fltk/fluid${KMPKG_HOST_EXECUTABLE_SUFFIX}")
endif()

set(runtime_dll "ON")
if(KMPKG_CRT_LINKAGE STREQUAL "static")
    set(runtime_dll "OFF")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DFLTK_BUILD_TEST=OFF
        -DOPTION_LARGE_FILE=ON
        -DHAVE_ALSA_ASOUNDLIB_H=OFF # tests only
        -DOPTION_USE_SYSTEM_ZLIB=ON
        -DOPTION_USE_SYSTEM_LIBPNG=ON
        -DOPTION_USE_SYSTEM_LIBJPEG=ON
        -DOPTION_BUILD_SHARED_LIBS=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=1
        "-DCocoa:STRING=-framework Cocoa" # avoid absolute path
        ${fluid_path_param}
        -DFLTK_MSVC_RUNTIME_DLL=${runtime_dll}
    MAYBE_UNUSED_VARIABLES
        Cocoa
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup()

kmpkg_copy_pdbs()

if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/fltk-config")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
    file(RENAME "${CURRENT_PACKAGES_DIR}/bin/fltk-config" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/fltk-config")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/fltk-config" "${CURRENT_PACKAGES_DIR}" "`dirname $0`/../..")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/fltk-config" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../.." IGNORE_UNCHANGED)
    if(NOT KMPKG_BUILD_TYPE)
        file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug")
        file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin/fltk-config" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/fltk-config")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/fltk-config" "${CURRENT_PACKAGES_DIR}" "`dirname $0`/../../..")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/fltk-config" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../.." IGNORE_UNCHANGED)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/fltk-config" "{prefix}/include" "{prefix}/../include")
    endif()
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/fluid${KMPKG_TARGET_EXECUTABLE_SUFFIX}" OR
   EXISTS "${CURRENT_PACKAGES_DIR}/bin/fluid${KMPKG_TARGET_BUNDLE_SUFFIX}")
   file(REMOVE "${CURRENT_PACKAGES_DIR}/bin/fluid.icns" "${CURRENT_PACKAGES_DIR}/debug/bin/fluid.icns")
   kmpkg_copy_tools(TOOL_NAMES fluid AUTO_CLEAN)
elseif(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE
        "${CURRENT_PACKAGES_DIR}/debug/bin"
        "${CURRENT_PACKAGES_DIR}/bin"
    )
endif()
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

foreach(FILE IN ITEMS Fl_Export.H fl_utf8.h)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/FL/${FILE}" "defined(FL_DLL)" "0")
    else()
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/FL/${FILE}" "defined(FL_DLL)" "1")
    endif()
endforeach()

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/fltk/UseFLTK.cmake" "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel;${SOURCE_PATH}" [[${CMAKE_CURRENT_LIST_DIR}/../../include]])

set(copyright_files "${SOURCE_PATH}/COPYING")
if("opengl" IN_LIST FEATURES)
    file(READ "${SOURCE_PATH}/src/freeglut_geometry.cxx" freeglut_copyright)
    string(REGEX MATCH " [*] Copyright.*" freeglut_copyright "${freeglut_copyright}" )
    string(REGEX REPLACE "[*]/.*" "" freeglut_copyright "${freeglut_copyright}")
    file(WRITE "${CURRENT_BUILDTREES_DIR}/Freeglut code copyright" "${freeglut_copyright}")
    list(APPEND copyright_files "${CURRENT_BUILDTREES_DIR}/Freeglut code copyright")

    file(READ "${SOURCE_PATH}/src/freeglut_teapot.cxx" teapot_copyright)
    string(REGEX MATCH " [*][^*]*Silicon Graphics, Inc.*" teapot_copyright "${teapot_copyright}")
    string(REGEX REPLACE "[*]/.*" "" teapot_copyright "${teapot_copyright}")
    file(WRITE "${CURRENT_BUILDTREES_DIR}/Original teapot code copyright" "${teapot_copyright}")
    list(APPEND copyright_files "${CURRENT_BUILDTREES_DIR}/Original teapot code copyright")
endif()
kmpkg_install_copyright(FILE_LIST ${copyright_files})
