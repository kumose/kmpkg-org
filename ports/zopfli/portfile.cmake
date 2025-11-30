kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/zopfli
    REF bd64b2f0553d4f1ef4e6627647c5d9fc8c71ffc0 # zopfli-1.0.3
    SHA512 3c99a4cdf3b2f0b619944bf2173ded8e10a89271fc4b2c713378b85d976a8580d15a473d5b0e6229f2911908fb1cc7397e516d618e61831c3becd65623214d94
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DZOPFLI_BUILD_INSTALL=ON
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

# Install tools
file(COPY "${CURRENT_PACKAGES_DIR}/bin/zopfli${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
    DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(COPY "${CURRENT_PACKAGES_DIR}/bin/zopflipng${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
    DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
kmpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}")

file(REMOVE
    "${CURRENT_PACKAGES_DIR}/bin/zopfli${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
    "${CURRENT_PACKAGES_DIR}/bin/zopflipng${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
    "${CURRENT_PACKAGES_DIR}/debug/bin/zopfli${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
    "${CURRENT_PACKAGES_DIR}/debug/bin/zopflipng${KMPKG_TARGET_EXECUTABLE_SUFFIX}"
)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT KMPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/Zopfli")

# kmpkg_cmake_config_fixup can not handles this on UNIX currently.
if(KMPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux" OR
   KMPKG_CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/zopfli/ZopfliConfig-debug.cmake"
            "\"\${_IMPORT_PREFIX}/debug/bin/zopfli\""
            "\"\${_IMPORT_PREFIX}/tools/zopfli/zopfli\""
            IGNORE_UNCHANGED
        )
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/zopfli/ZopfliConfig-debug.cmake"
            "\"\${_IMPORT_PREFIX}/debug/bin/zopflipng\""
            "\"\${_IMPORT_PREFIX}/tools/zopfli/zopflipng\""
            IGNORE_UNCHANGED
        )
    endif()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/zopfli/ZopfliConfig-release.cmake"
        "\"\${_IMPORT_PREFIX}/bin/zopfli\""
        "\"\${_IMPORT_PREFIX}/tools/zopfli/zopfli\""
        IGNORE_UNCHANGED
    )
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/zopfli/ZopfliConfig-release.cmake"
        "\"\${_IMPORT_PREFIX}/bin/zopflipng\""
        "\"\${_IMPORT_PREFIX}/tools/zopfli/zopflipng\""
        IGNORE_UNCHANGED
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
