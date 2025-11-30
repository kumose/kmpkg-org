kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO shibatch/sleef
    REF ${VERSION}
    SHA512 9b47667b33a685308aa65f848b7ee620e9e8783ca4851fd57e873f34310b486fb351813f573f2a7a71b6bdc5c8b2c5ef4eb4f66c890ddfbfada7bb9d74626c0b
    HEAD_REF master
    PATCHES
        android-neon.diff
        exclude-testerutil.diff
        export-link-libs.diff
        sleefdft.pc.diff
        seh-cpu-ext.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS options
    FEATURES
        dft     SLEEF_BUILD_DFT
        dft     SLEEF_ENFORCE_DFT
)

if(KMPKG_CROSSCOMPILING)
    list(APPEND options "-DNATIVE_BUILD_DIR=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/${PORT}")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        -DSLEEF_BUILD_LIBM=ON
        -DSLEEF_BUILD_QUAD=ON
        -DSLEEF_BUILD_GNUABI_LIBS=${KMPKG_TARGET_IS_LINUX}
        -DSLEEF_BUILD_TESTS=OFF
        -DSLEEF_DISABLE_SSL=ON
        -DSLEEF_DISABLE_SVE=ON  # arm64 build issues, officially unmaintained
        -DSLEEF_ENABLE_TLFLOAT=OFF
        -DSLEEF_ENABLE_TESTER4=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/sleef)
kmpkg_fixup_pkgconfig()

if(NOT KMPKG_CROSSCOMPILING)
    set(tools mkrename qmkrename mkalias mkdisp qmkdisp)
    if("dft" IN_LIST FEATURES)
        list(APPEND tools mkdispatch mkunroll)
    endif()
    kmpkg_copy_tools(
        TOOL_NAMES ${tools}
        SEARCH_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin"
        DESTINATION "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}/bin"
        AUTO_CLEAN)
endif()    

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")

