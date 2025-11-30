# The project's CMakeLists.txt uses Python to select source files. Check if it is available in advance.
kmpkg_find_acquire_program(PYTHON3)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pytorch/fbgemm
    REF 73a64e75ff31be7ece6f68929ee5682b0bf9eb10
    SHA512 2757d986a977d14bd32d482452627b55aae216f77a262b2b1b88a643a2977c6c27c5a99ee91b7a7bdbb66248239ecc1a57d1953251049d787317b6355369af26
    PATCHES
        fix-cmakelists.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUSE_SANITIZER=OFF
        -DFBGEMM_BUILD_TESTS=OFF
        -DFBGEMM_BUILD_BENCHMARKS=OFF
        -DPYTHON_EXECUTABLE=${PYTHON3} # inject the path instead of find_package(Python)
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME fbgemmLibrary)

# this internal header is required by pytorch
file(INSTALL     "${SOURCE_PATH}/src/RefImplementations.h"
     DESTINATION "${CURRENT_PACKAGES_DIR}/include/fbgemm/src")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
