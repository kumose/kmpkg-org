kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ggml-org/ggml
    REF v${VERSION}
    SHA512 e2c47e5bcdf3eda66757e63b93f4adf56e7894edeed0d39f182c850cae4dddb49f3cf82ac9e8546dfcd48abf02b7bf0a64d22bacba4360b2f7ef2cb09855eadb
    HEAD_REF master
    PATCHES
        cmake-config.diff
        pkgconfig.diff
        relax-link-options.diff
        vulkan-shaders-gen.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        blas     GGML_BLAS
        cuda     GGML_CUDA
        metal    GGML_METAL
        opencl   GGML_OPENCL
        openmp   GGML_OPENMP
        vulkan   GGML_VULKAN
)

if("blas" IN_LIST FEATURES)
    kmpkg_find_acquire_program(PKGCONFIG)
    list(APPEND FEATURE_OPTIONS
        "-DCMAKE_REQUIRE_FIND_PACKAGE_BLAS=ON" # workaround message(ERROR ...)
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
    )
endif()

if("cuda" IN_LIST FEATURES)
    kmpkg_find_cuda(OUT_CUDA_TOOLKIT_ROOT cuda_toolkit_root)
    list(APPEND FEATURE_OPTIONS
        "-DCMAKE_CUDA_COMPILER=${NVCC}"
        "-DCUDAToolkit_ROOT=${cuda_toolkit_root}"
    )
endif()

if("opencl" IN_LIST FEATURES)
    kmpkg_find_acquire_program(PYTHON3)
    list(APPEND FEATURE_OPTIONS
        "-DPython3_EXECUTABLE=${PYTHON3}"
    )
endif()

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW AND KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    message(STATUS "The CPU backend is not supported for arm64 with MSVC.")
    list(APPEND FEATURE_OPTIONS
        "-DGGML_CPU=OFF"
    )
    if(FEATURES STREQUAL "core")
        message(WARNING "No backend enabled!")
    endif()
endif()

if("vulkan" IN_LIST FEATURES AND KMPKG_CROSSCOMPILING)
    list(APPEND FEATURE_OPTIONS
        "-DVulkan_GLSLC_EXECUTABLE=${CURRENT_HOST_INSTALLED_DIR}/tools/shaderc/glslc${KMPKG_HOST_EXECUTABLE_SUFFIX}"
        "-DVULKAN_SHADERS_GEN_EXECUTABLE=${CURRENT_HOST_INSTALLED_DIR}/tools/${PORT}/vulkan-shaders-gen${KMPKG_HOST_EXECUTABLE_SUFFIX}"
    )
endif()

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static"  GGML_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DGGML_STATIC=${GGML_STATIC}
        -DGGML_CCACHE=OFF
        -DGGML_BUILD_NUMBER=1
        -DGGML_BUILD_TESTS=OFF
        -DGGML_BUILD_EXAMPLES=OFF
        -DGGML_HIP=OFF
        -DGGML_SYCL=OFF
        ${FEATURE_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        PKG_CONFIG_EXECUTABLE
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME ggml CONFIG_PATH "lib/cmake/ggml")
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/ggml.h" "#ifdef GGML_SHARED" "#if 1")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/ggml-backend.h" "#ifdef GGML_BACKEND_SHARED" "#if 1")
endif()

if("vulkan" IN_LIST FEATURES AND NOT KMPKG_CROSSCOMPILING)
    kmpkg_copy_tools(TOOL_NAMES vulkan-shaders-gen AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
