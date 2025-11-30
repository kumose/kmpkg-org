
# We use the release tarball from GitHub instead of the sources in the repo because:
#  - igraph will not compile from the git sources unless there is an actual git repository to back it. This is because it detects the version from git tags. The release tarball has the version hard-coded.
#  - The release tarball contains pre-generated parser sources, which eliminates the dependency on bison/flex.

kmpkg_download_distfile(ARCHIVE
    URLS "https://github.com/igraph/igraph/releases/download/${VERSION}/igraph-${VERSION}.tar.gz"
    FILENAME "igraph-${VERSION}.tar.gz"
    SHA512 2a2b7930adf9cf9de550e1a1348260e0c58e4d8b387cb7b6805aad2d501272cd846d1948bde9f6cc0432d904e6b1fb1f17e5e8c81f5bd146aef2560b7a7042c8
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
      "glpk-uwp.patch" # patch GLPK for UWP compatibility
      "constant-nan.patch" # Workaround https://developercommunity.visualstudio.com/t/NAN-is-no-longer-compile-time-constant-i/10688907
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        graphml         IGRAPH_GRAPHML_SUPPORT
        openmp          IGRAPH_OPENMP_SUPPORT
)

# Allow cross-compilation. See https://igraph.org/c/html/latest/igraph-Installation.html#igraph-Installation-cross-compiling
set(ARITH_H "")
if (KMPKG_TARGET_IS_OSX)
    set(ARITH_H ${CURRENT_PORT_DIR}/arith_osx.h)
elseif (KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_UWP)
    if (KMPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "arm")
        set(ARITH_H ${CURRENT_PORT_DIR}/arith_win32.h)
    elseif (KMPKG_TARGET_ARCHITECTURE STREQUAL "x64" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        set(ARITH_H ${CURRENT_PORT_DIR}/arith_win64.h)
    endif()
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DIGRAPH_ENABLE_LTO=AUTO
        # ARPACK not yet available in kmpkg.
        -DIGRAPH_USE_INTERNAL_ARPACK=ON
        # GLPK is not yet available in kmpkg.
        -DIGRAPH_USE_INTERNAL_GLPK=ON
        # Currently, external GMP provides no performance or functionality benefits.
        -DIGRAPH_USE_INTERNAL_GMP=ON
        # PLFIT is not yet available in kmpkg.
        -DIGRAPH_USE_INTERNAL_PLFIT=ON
        # Use BLAS and LAPACK from kmpkg
        -DIGRAPH_USE_INTERNAL_BLAS=OFF
        -DIGRAPH_USE_INTERNAL_LAPACK=OFF
        -DF2C_EXTERNAL_ARITH_HEADER=${ARITH_H}
        -DIGRAPH_WARNINGS_AS_ERRORS=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/igraph)

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

kmpkg_fixup_pkgconfig()
