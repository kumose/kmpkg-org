kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "MuGdxy/muda"
    REF "${VERSION}"
    SHA512 36ca58a8a01c3a6e8ef84138846ade2346ea73e9160ff47b280ae44ecc0ccfa9471f2a0cf8707d80c193e211c664203002889549534db7943e20487a960d9068
    HEAD_REF mini20
)

kmpkg_check_features(OUT_FEATURE_OPTIONS options
    FEATURES
        compute-graph   MUDA_WITH_COMPUTE_GRAPH
)

kmpkg_find_cuda(OUT_CUDA_TOOLKIT_ROOT cuda_toolkit_root)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        "-DCMAKE_CUDA_COMPILER=${NVCC}"
        "-DCUDAToolkit_ROOT=${cuda_toolkit_root}"
        "-DMUDA_BUILD_EXAMPLE=OFF"
        "-DMUDA_BUILD_TEST=OFF"
        "-DMUDA_WITH_CHECK=ON"
        "-DMUDA_WITH_NVTX3=OFF"
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
