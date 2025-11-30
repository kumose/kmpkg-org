kmpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
kmpkg_add_to_path("${PYTHON3_DIR}")

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Z3Prover/z3
  REF z3-${VERSION}
  SHA512 3037a6c9077cf5b5bbc9db89973311e66233144ad6c8fc8da9fb2aa35bb34944068874868cf571b247130251a8361cbd1e24288768cc49e4166985cf0ca921a2
  HEAD_REF master
  PATCHES
      fix-install-path.patch
      remove-flag-overrides.patch
)

if (KMPKG_LIBRARY_LINKAGE STREQUAL "static")
  set(BUILD_STATIC "-DZ3_BUILD_LIBZ3_SHARED=OFF")
endif()

kmpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
    ${BUILD_STATIC}
    -DZ3_BUILD_TEST_EXECUTABLES=OFF
    -DZ3_ENABLE_EXAMPLE_TARGETS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/z3)
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

kmpkg_fixup_pkgconfig()
