kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/solid
    REF v5.98.0
    SHA512 9f0aed7f8ea29a6132ca9c99c4c744ca5580bb3f7be1712e27d1fc3ae47b2edac26a5ce20abddef4d9998612f2386e1cc6915504c02897f2b3ebcec01cd26208
    HEAD_REF master
    PATCHES
        001_fix_libmount.patch
        002_fix_imobile.patch
)
# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

if(KMPKG_TARGET_IS_OSX)
    # On Darwin platform, the bundled version of 'bison' may be too old (< 3.0).
    kmpkg_find_acquire_program(BISON)
    execute_process(
        COMMAND "${BISON}" --version
        OUTPUT_VARIABLE BISON_OUTPUT
    )
    string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" BISON_VERSION "${BISON_OUTPUT}")
    set(BISON_MAJOR ${CMAKE_MATCH_1})
    set(BISON_MINOR ${CMAKE_MATCH_2})
    message(STATUS "Using bison: ${BISON_MAJOR}.${BISON_MINOR}.${CMAKE_MATCH_3}")
    if(NOT (BISON_MAJOR GREATER_EQUAL 3 AND BISON_MINOR GREATER_EQUAL 0))
        message(WARNING "${PORT} requires bison version greater than one provided by macOS, please use \`brew install bison\` to install a newer bison.")
    endif()
endif()

kmpkg_find_acquire_program(BISON)
kmpkg_find_acquire_program(FLEX)

get_filename_component(FLEX_DIR "${FLEX}" DIRECTORY)
get_filename_component(BISON_DIR "${BISON}" DIRECTORY)

kmpkg_add_to_path(PREPEND "${FLEX_DIR}")
kmpkg_add_to_path(PREPEND "${BISON_DIR}")

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        libmount    CMAKE_REQUIRE_FIND_PACKAGE_LibMount
        imobile     CMAKE_REQUIRE_FIND_PACKAGE_IMobileDevice
        imobile     CMAKE_REQUIRE_FIND_PACKAGE_PList
    INVERTED_FEATURES
        libmount    CMAKE_DISABLE_FIND_PACKAGE_LibMount
        imobile     CMAKE_DISABLE_FIND_PACKAGE_IMobileDevice
        imobile     CMAKE_DISABLE_FIND_PACKAGE_PList
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_QMLDIR=qml
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/KF5Solid)
kmpkg_copy_pdbs()

kmpkg_copy_tools(
    TOOL_NAMES solid-hardware5
    AUTO_CLEAN
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    # Until https://github.com/microsoft/kmpkg/pull/34091
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*")
kmpkg_install_copyright(FILE_LIST ${LICENSE_FILES})
