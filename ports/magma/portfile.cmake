
set(opts "")
if(KMPKG_TARGET_IS_WINDOWS AND KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
  set(opts
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS:BOOL=ON
    -DCMAKE_CUDA_SEPARABLE_COMPILATION:BOOL=OFF
  )
endif()

kmpkg_download_distfile(
  dist_file
  URLS https://icl.utk.edu/projectsfiles/magma/downloads/magma-${VERSION}.tar.gz
  FILENAME magma-${VERSION}.tar.gz
  SHA512 233beb3d2809c12a27a9b7a6a0eb0bec0ade91fa6bf1a63e1ca4d491491ed5a8729996ac8fbf68ab8d678acab6ed56b7728689358a7b76b20b101227a9851c16
)

kmpkg_extract_source_archive(
  src_path
  ARCHIVE "${dist_file}"
  PATCHES
    disable-openmp-msvc.patch
    no-tests.patch
    clang-cuda.patch
    fix-cmake4.patch
)

kmpkg_find_cuda(OUT_CUDA_TOOLKIT_ROOT cuda_toolkit_root) 

kmpkg_cmake_configure(
  SOURCE_PATH "${src_path}"
  OPTIONS
    -DMAGMA_ENABLE_CUDA=ON
    -DMAGMA_ENABLE_HIP=OFF # HIP is backend and seems additive?!
    -DUSE_FORTRAN=OFF
    "-DCMAKE_CUDA_COMPILER:FILEPATH=${NVCC}"
    "-DCUDAToolkit_ROOT=${cuda_toolkit_root}"
    ${opts}
)
kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()

file(READ "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/magma.pc" contents)
string(REGEX REPLACE "Cflags: [^\n]+" "Cflags: -I\${includedir}" contents "${contents}")
file(WRITE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/magma.pc" "${contents}")

if(NOT KMPKG_BUILD_TYPE)
  file(READ "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/magma.pc" contents)
  string(REGEX REPLACE "Cflags: [^\n]+" "Cflags: -I\${includedir}" contents "${contents}")
  file(WRITE "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/magma.pc" "${contents}")
endif()

file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${src_path}/COPYRIGHT")
