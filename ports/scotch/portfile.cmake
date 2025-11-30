if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()
kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.inria.fr/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO scotch/scotch
    REF "v${VERSION}"
    SHA512 9566ca800fd47df63844df6ff8b0fbbe8efbdea549914dfe9bf00d3d104a8c5631cfbef69e2677de68dcdb93addaeed158e6f6a373b5afe8cec82ac358946b65
    HEAD_REF master
    PATCHES fix-build.patch
)

kmpkg_find_acquire_program(FLEX)
cmake_path(GET FLEX PARENT_PATH FLEX_DIR)
kmpkg_add_to_path("${FLEX_DIR}")

kmpkg_find_acquire_program(BISON)
cmake_path(GET BISON PARENT_PATH BISON_DIR)
kmpkg_add_to_path("${BISON_DIR}")

if(KMPKG_TARGET_IS_WINDOWS)
    #Uses gcc intrinsics otherwise
    string(APPEND KMPKG_C_FLAGS     " -DGRAPHMATCHNOTHREAD")
    string(APPEND KMPKG_CXX_FLAGS   " -DGRAPHMATCHNOTHREAD")
endif()

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        ptscotch    BUILD_PTSCOTCH
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        -DBUILD_LIBESMUMPS=OFF
        -DBUILD_LIBSCOTCHMETIS=OFF
        -DTHREADS=ON
        -DMPI_THREAD_MULTIPLE=OFF
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/scotch")
kmpkg_copy_tools(TOOL_NAMES
    acpl amk_ccc amk_fft2 amk_grf amk_hy
    amk_m2 amk_p2 atst gbase gcv gmap gmk_hy
    gmk_m2 gmk_m3 gmk_msh gmk_ub2 gmtst
    gord gotst gscat gtst mcv mmk_m2 mmk_m3
    mord mtst
    AUTO_CLEAN
    )

if ("ptscotch" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES dggath dgmap dgord dgscat dgtst AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/doc/CeCILL-C_V1-en.txt")

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/scotch/SCOTCHConfig.cmake" "find_dependency(Threads)" "if(NOT WIN32)\nfind_dependency(Threads)\nelse()\nfind_dependency(PThreads4W)\nendif()")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include"
                    "${CURRENT_PACKAGES_DIR}/debug/man"
                    "${CURRENT_PACKAGES_DIR}/man"
                    "${CURRENT_PACKAGES_DIR}/debug/share"
                    )
