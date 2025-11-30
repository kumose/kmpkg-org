# Enable static build in UNIX
if (KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)
endif()

set(LIBMODMAN_VER 2.0.1)

kmpkg_download_distfile(ARCHIVE
    URLS "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libmodman/libmodman-${LIBMODMAN_VER}.zip"
    FILENAME "libmodman-${LIBMODMAN_VER}.zip"
    SHA512 1fecc0fa3637c4aa86d114f5bc991605172d39183fa0f39d8c7858ef5d0d894152025bd426de4dd017a41372d800bf73f53b2328c57b77352a508e12792729fa
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS FEATURES 
    tests BUILD_TESTING
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
        fix-install-path.patch
        fix-undefined-typeid.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH share/libmodman)
kmpkg_copy_pdbs()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake"
          "${CMAKE_CURRENT_LIST_DIR}/usage"
          DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
