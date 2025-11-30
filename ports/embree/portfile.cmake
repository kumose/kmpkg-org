if(EXISTS "${CURRENT_INSTALLED_DIR}/share/embree/embree-config.cmake")
    message(FATAL_ERROR "Port embree3 must be removed before installing embree.")
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO RenderKit/embree
    REF v${VERSION}
    SHA512 5e77a033192ade6562b50d32c806c6a467580722898ca52ccfe002b51279314055e9c0e6c969651b0d03716d04ab249301340cd2790556a0dbfb8c296e8f0574
    HEAD_REF master
    PATCHES
        avoid-library-conflicts.diff
        cmake-config.diff
        no-runtime-install.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" static EMBREE_STATIC_LIB)
string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" static EMBREE_STATIC_RUNTIME)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        backface-culling      EMBREE_BACKFACE_CULLING 
        compact-polys         EMBREE_COMPACT_POLYS   
        filter-function       EMBREE_FILTER_FUNCTION  
        ray-mask              EMBREE_RAY_MASK 
        ray-packets           EMBREE_RAY_PACKETS 

        geometry-triangle     EMBREE_GEOMETRY_TRIANGLE
        geometry-quad         EMBREE_GEOMETRY_QUAD
        geometry-curve        EMBREE_GEOMETRY_CURVE
        geometry-subdivision  EMBREE_GEOMETRY_SUBDIVISION
        geometry-user         EMBREE_GEOMETRY_USER
        geometry-instance     EMBREE_GEOMETRY_INSTANCE
        geometry-grid         EMBREE_GEOMETRY_GRID
        geometry-point        EMBREE_GEOMETRY_POINT
)

if("tasking-tbb" IN_LIST FEATURES)
    set(EMBREE_TASKING_SYSTEM "TBB")
    list(APPEND FEATURE_OPTIONS "-DKMPKG_LOCK_FIND_PACKAGE_TBB=ON")
else()
    set(EMBREE_TASKING_SYSTEM "INTERNAL")
endif()

if(KMPKG_TARGET_IS_OSX AND KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    # "Using Embree as static library is not supported with AppleClang >= 9.0
    #  when multiple ISAs are selected."
    # The port follows linkage and selects a single ISA for static linkage.
    # Per-port customization may override KMPKG_LIBRARY_LINKAGE or ISA flags.
    list(APPEND FEATURE_OPTIONS "-DEMBREE_MAX_ISA=NONE")
    if(KMPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        list(APPEND FEATURE_OPTIONS
            -DEMBREE_ISA_SSE2=OFF
            -DEMBREE_ISA_SSE42=OFF
            -DCOMPILER_SUPPORTS_AVX=OFF
            -DEMBREE_ISA_AVX2=ON
            -DCOMPILER_SUPPORTS_AVX512=OFF
        )
    endif()
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE  # in-source CONFIGURE_FILE
    OPTIONS
        ${FEATURE_OPTIONS}
        -DEMBREE_INSTALL_DEPENDENCIES=OFF
        -DEMBREE_ISPC_SUPPORT=OFF
        -DEMBREE_STATIC_RUNTIME=${EMBREE_STATIC_RUNTIME}
        -DEMBREE_STATIC_LIB=${EMBREE_STATIC_LIB}
        -DEMBREE_TASKING_SYSTEM:STRING=${EMBREE_TASKING_SYSTEM}
        -DEMBREE_TUTORIALS=OFF
    MAYBE_UNUSED_VARIABLES
        EMBREE_STATIC_RUNTIME
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup()

file(RENAME "${CURRENT_PACKAGES_DIR}/share/doc" "${CURRENT_PACKAGES_DIR}/share/${PORT}/doc")
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/embree-vars.csh"
    "${CURRENT_PACKAGES_DIR}/debug/embree-vars.sh"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/embree-vars.csh"
    "${CURRENT_PACKAGES_DIR}/embree-vars.sh"
    "${CURRENT_PACKAGES_DIR}/share/man"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/doc/LICENSE.txt"
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(
    COMMENT "The embree package contains third-party software which may be governed by
             separate license terms."
    FILE_LIST "${SOURCE_PATH}/LICENSE.txt"
)
