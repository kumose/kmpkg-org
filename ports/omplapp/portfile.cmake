kmpkg_buildpath_length_warning(37)

# See https://github.com/ompl/omplapp/blob/1.7.0/src/omplapp/CMakeLists.txt#L20-L24
if (KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
else()
    kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ompl/omplapp
    REF "${VERSION}"
    SHA512 cb68791c39b6b2aceb4204c72b7678f2f0d895f0ae2500803f93dab0918f85c322d62c28693c60b50c6b7bc0fb4c448a33e3951c608a68befe21227c1c68a7ec
    HEAD_REF main
    PATCHES
        0001-use-external-libs.patch
)

# Remove internal find module files
file(GLOB find_modules "${SOURCE_PATH}/CMakeModules/Find*.cmake")
file(REMOVE_RECURSE ${find_modules})

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        opengl CMAKE_REQUIRE_FIND_PACKAGE_OpenGL
    INVERTED_FEATURES
        opengl CMAKE_DISABLE_FIND_PACKAGE_OpenGL
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        ${FEATURE_OPTIONS}
        -DOMPL_VERSIONED_INSTALL=OFF
        -DOMPL_BUILD_DEMOS=OFF
        -DOMPL_BUILD_PYBINDINGS=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_flann=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_PQP=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
)

kmpkg_cmake_install()

# Extending the ompl CMake package
kmpkg_cmake_config_fixup(PACKAGE_NAME ompl)

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/omplapp/config.h" "#define OMPLAPP_RESOURCE_DIR \"${CURRENT_PACKAGES_DIR}/share/ompl/resources\"" "")

kmpkg_copy_tools(TOOL_NAMES ompl_benchmark AUTO_CLEAN)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/include/omplapp/CMakeFiles"
    "${CURRENT_PACKAGES_DIR}/share/man"
    "${CURRENT_PACKAGES_DIR}/share/ompl/demos"
    "${CURRENT_PACKAGES_DIR}/share/ompl/resources"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
