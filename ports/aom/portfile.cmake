kmpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://aomedia.googlesource.com/aom"
    REF d772e334cc724105040382a977ebb10dfd393293
    HEAD_REF main
    PATCHES
        aom-rename-static.diff
        aom-uninitialized-pointer.diff
)

kmpkg_find_acquire_program(NASM)
kmpkg_find_acquire_program(PERL)

set(aom_target_cpu "")
if(KMPKG_TARGET_IS_UWP OR (KMPKG_TARGET_IS_WINDOWS AND KMPKG_TARGET_ARCHITECTURE MATCHES "^arm"))
    # UWP + aom's assembler files result in weirdness and build failures
    # Also, disable assembly on ARM and ARM64 Windows to fix compilation issues.
    set(aom_target_cpu "-DAOM_TARGET_CPU=generic")
endif()

if(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm" AND KMPKG_TARGET_IS_LINUX)
    set(aom_target_cpu "-DENABLE_NEON=OFF")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${aom_target_cpu}
        -DENABLE_DOCS=OFF
        -DENABLE_EXAMPLES=OFF
        -DENABLE_TESTDATA=OFF
        -DENABLE_TESTS=OFF
        -DENABLE_TOOLS=OFF
        -DTHREADS_PREFER_PTHREAD_FLAG=ON
        "-DCMAKE_ASM_NASM_COMPILER=${NASM}"
        "-DPERL_EXECUTABLE=${PERL}"
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/AOM)
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
