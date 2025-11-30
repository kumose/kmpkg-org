kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsndfile/libsndfile
    REF 1.2.2
    SHA512 fb8b4d367240a8ac9d55be6f053cb19419890691c56a8552d1600d666257992b6e8e41a413a444c9f2d6c5d71406013222c92a3bfa67228944a26475444240a1
    HEAD_REF master
    PATCHES
        001-avoid-installing-find-modules.patch
        mp3lame-static.diff
)

if(KMPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    kmpkg_find_acquire_program(PYTHON3)
endif()

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        external-libs ENABLE_EXTERNAL_LIBS
        mpeg ENABLE_MPEG
        regtest BUILD_REGTEST
)

if(KMPKG_TARGET_IS_UWP)
    set(KMPKG_C_FLAGS "/sdl- ${KMPKG_C_FLAGS}")
    set(KMPKG_CXX_FLAGS "/sdl- ${KMPKG_CXX_FLAGS}")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_BOW_DOCS=OFF
        -DBUILD_PROGRAMS=OFF
        -DBUILD_REGTEST=OFF
        -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON
        -DPYTHON_EXECUTABLE=${PYTHON3}
        ${FEATURE_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        PYTHON_EXECUTABLE
)

kmpkg_cmake_install()

if(EXISTS "${CURRENT_PACKAGES_DIR}/cmake")
    set(CONFIG_PATH cmake)
else()
    set(CONFIG_PATH lib/cmake/SndFile)
endif()

kmpkg_cmake_config_fixup(PACKAGE_NAME SndFile CONFIG_PATH "${CONFIG_PATH}")
kmpkg_fixup_pkgconfig(SYSTEM_LIBRARIES m)

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
