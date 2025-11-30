kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "capstone-engine/capstone"
    REF "${VERSION}"
    SHA512 d4ed08a2ab4ed8ede51a163e98542129d6441889cf6936ac9e3f8027fb2dfcbb04a7aacba14c2a007e788790bb3939c173b47db3d95f5dd9eafce2f30ff493e1
    HEAD_REF next
    PATCHES
        001-silence-windows-crt-secure-warnings.patch
        002-force-exportname-capstone.patch
)

string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" STATIC_CRT)
string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" CAPSTONE_STATIC)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "arm"         CAPSTONE_ARM_SUPPORT
        "arm64"       CAPSTONE_ARM64_SUPPORT
        "evm"         CAPSTONE_EVM_SUPPORT
        "m680x"       CAPSTONE_M680X_SUPPORT
        "m68k"        CAPSTONE_M68K_SUPPORT
        "mips"        CAPSTONE_MIPS_SUPPORT
        "ppc"         CAPSTONE_PPC_SUPPORT
        "sparc"       CAPSTONE_SPARC_SUPPORT
        "sysz"        CAPSTONE_SYSZ_SUPPORT
        "tms320c64x"  CAPSTONE_TMS320C64X_SUPPORT
        "x86"         CAPSTONE_X86_SUPPORT
        "xcore"       CAPSTONE_XCORE_SUPPORT
        "mos65xx"     CAPSTONE_MOS65XX_SUPPORT
        "tricore"     CAPSTONE_TRICORE_SUPPORT
        "wasm"        CAPSTONE_WASM_SUPPORT
        "bpf"         CAPSTONE_BPF_SUPPORT
        "riscv"       CAPSTONE_RISCV_SUPPORT
        "diet"        CAPSTONE_BUILD_DIET
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCAPSTONE_ARCHITECTURE_DEFAULT=OFF
        -DCAPSTONE_BUILD_TESTS=OFF
        -DCAPSTONE_BUILD_CSTOOL=OFF
        -DCAPSTONE_BUILD_STATIC_RUNTIME=${STATIC_CRT}
        -DBUILD_STATIC_RUNTIME=${STATIC_CRT}
        -DBUILD_STATIC_LIBS=${CAPSTONE_STATIC}
        ${FEATURE_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        CAPSTONE_BUILD_STATIC_RUNTIME
        BUILD_STATIC_RUNTIME
        BUILD_STATIC_LIBS
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(
    FILE_LIST "${SOURCE_PATH}/LICENSE.TXT"
)
