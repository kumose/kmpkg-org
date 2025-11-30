# Update both, literally.
set(COLMAP_REF 3.12.6 "4d5b60e19ad268072adaf1267d21fa38a9a828ca")

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO colmap/colmap
    REF "${VERSION}"
    SHA512 718e4542a128fbe39dd36a5e2e6d013c201ef7e23d0f6f38acc10aa5f505185389d8c9b8a75f02846cac4fd426adb75250cc32d32d427496b275ad4632a05ddb
    HEAD_REF main
    PATCHES
        no-glu.diff
)

if (NOT TRIPLET_SYSTEM_ARCH STREQUAL "x64" AND ("cuda" IN_LIST FEATURES OR "cuda-redist" IN_LIST FEATURES))
    message(FATAL_ERROR "Feature cuda and cuda-redist require x64 triplet.")
endif()

# set GIT_COMMIT_ID and GIT_COMMIT_DATE
if(DEFINED KMPKG_HEAD_VERSION)
    set(GIT_COMMIT_ID "${KMPKG_HEAD_VERSION}")
elseif(NOT VERSION IN_LIST COLMAP_REF)
    message(FATAL_ERROR "Version ${VERSION} missing in COLMAP_REF (${COLMAP_REF})")
else()
    list(GET COLMAP_REF 1 GIT_COMMIT_ID)
endif()

string(TIMESTAMP COLMAP_GIT_COMMIT_DATE "%Y-%m-%d")

foreach(FEATURE ${FEATURE_OPTIONS})
    message(STATUS "${FEATURE}")
endforeach()

set(CUDA_ENABLED OFF)
set(GUI_ENABLED OFF)
set(CGAL_ENABLED OFF)
set(OPENMP_ENABLED ON)

if("cuda" IN_LIST FEATURES)
    set(CUDA_ENABLED ON)
    set(CUDA_ARCHITECTURES "native")
endif()

if("cuda-redist" IN_LIST FEATURES)
    set(CUDA_ENABLED ON)
    set(CUDA_ARCHITECTURES "all-major")
endif()

if("gui" IN_LIST FEATURES)
    set(GUI_ENABLED ON)
endif()

if("cgal" IN_LIST FEATURES)
    set(CGAL_ENABLED ON)
endif()

if (KMPKG_TARGET_IS_OSX AND KMPKG_TARGET_ARCHITECTURE MATCHES "arm")
    set(OPENMP_ENABLED OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DCUDA_ENABLED=${CUDA_ENABLED}
        -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES}
        -DGUI_ENABLED=${GUI_ENABLED}
        -DGIT_COMMIT_ID=${GIT_COMMIT_ID}
        -DGIT_COMMIT_DATE=${COLMAP_GIT_COMMIT_DATE}
        -DOPENMP_ENABLED=${OPENMP_ENABLED}
        -DCGAL_ENABLED=${CGAL_ENABLED}
        -DTESTS_ENABLED=OFF
        -DFETCH_POSELIB=OFF
        -DFETCH_FAISS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup()

file(GLOB TOOL_FILENAMES "${CURRENT_PACKAGES_DIR}/bin/*")
foreach(TOOL_FILENAME ${TOOL_FILENAMES})
    get_filename_component(TEST_TOOL_NAME ${TOOL_FILENAME} NAME_WLE)
    list(APPEND COLMAP_TOOL_NAMES "${TEST_TOOL_NAME}")
endforeach()

kmpkg_copy_tools(TOOL_NAMES ${COLMAP_TOOL_NAMES} AUTO_CLEAN)

# remove empty folders and unused files
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/include/colmap/exe"
    "${CURRENT_PACKAGES_DIR}/include/colmap/tools"
    "${CURRENT_PACKAGES_DIR}/include/colmap/ui/media"
    "${CURRENT_PACKAGES_DIR}/include/colmap/ui/shaders"
    "${CURRENT_PACKAGES_DIR}/COLMAP.bat"
    "${CURRENT_PACKAGES_DIR}/RUN_TESTS.bat"
    "${CURRENT_PACKAGES_DIR}/debug/COLMAP.bat"
    "${CURRENT_PACKAGES_DIR}/debug/RUN_TESTS.bat"
    "${CURRENT_PACKAGES_DIR}/debug/bin"
)

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.txt")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
