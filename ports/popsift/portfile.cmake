kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO alicevision/popsift
    REF v${VERSION}
    SHA512 374a00542ff46ac8a8cf31b7a62c834e4e148c5f9ddd5f6a128e4284e637242c0ce55bf3ee6524e6555c8402332ec8863ca921cef36c0bacd9a1ada6c8e09b55
    HEAD_REF develop
)

kmpkg_find_cuda(OUT_CUDA_TOOLKIT_ROOT CUDA_TOOLKIT_ROOT)

# This is necessary as popsift uses cuda as first class language in CMake and 
# depending on the version of CMake it might fail to find nvcc compiler.
if(CMAKE_HOST_WIN32)
    set(NVCC_PATH ${CUDA_TOOLKIT_ROOT}/bin/nvcc.exe)
else()
    set(NVCC_PATH ${CUDA_TOOLKIT_ROOT}/bin/nvcc)
endif()

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        apps       PopSift_BUILD_EXAMPLES
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        "-DCMAKE_CUDA_COMPILER=${NVCC_PATH}"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/PopSift)

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

# copy the apps in tools directory
if ("apps" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES popsift-demo AUTO_CLEAN)
endif()

file(INSTALL "${SOURCE_PATH}/COPYING.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
