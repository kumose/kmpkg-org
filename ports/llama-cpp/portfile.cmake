kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ggml-org/llama.cpp
    REF b${VERSION}
    SHA512 c823aa1739a84b6fd50255a2c2c92e9da1cec55c62791886424b4ac126759bf9b63710e3c366fac6a004dbed0175b77756acef85ad495792142e671381b2026a
    HEAD_REF master
    PATCHES
        cmake-config.diff
        pkgconfig.diff
)
file(REMOVE_RECURSE "${SOURCE_PATH}/ggml/include" "${SOURCE_PATH}/ggml/src")

kmpkg_check_features(OUT_FEATURE_OPTIONS options
    FEATURES
        download    LLAMA_CURL
        tools       LLAMA_BUILD_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        -DGGML_CCACHE=OFF
        -DLLAMA_ALL_WARNINGS=OFF
        -DLLAMA_BUILD_TESTS=OFF
        -DLLAMA_BUILD_EXAMPLES=OFF
        -DLLAMA_BUILD_SERVER=OFF
        -DLLAMA_USE_SYSTEM_GGML=ON
        -DKMPKG_LOCK_FIND_PACKAGE_Git=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/llama")
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/gguf-py/gguf" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}/gguf-py")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin/convert_hf_to_gguf.py" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/convert-hf-to-gguf.py")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/convert_hf_to_gguf.py")

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(
        TOOL_NAMES
            llama-batched-bench
            llama-bench
            llama-cli
            llama-cvector-generator
            llama-export-lora
            llama-gguf-split
            llama-imatrix
            llama-mtmd-cli
            llama-perplexity
            llama-quantize
            llama-run
            llama-tokenize
            llama-tts
        AUTO_CLEAN
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_clean_executables_in_bin(FILE_NAMES none)

set(gguf-py-license "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/gguf-py LICENSE")
file(COPY_FILE "${SOURCE_PATH}/gguf-py/LICENSE" "${gguf-py-license}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" "${gguf-py-license}")
