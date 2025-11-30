kmpkg_download_distfile(ARCHIVE
    URLS "https://angelcode.com/angelscript/sdk/files/angelscript_${VERSION}.zip"
    FILENAME "angelscript_${VERSION}.zip"
    SHA512 87c94042932f15d07fe6ede4c3671b1f73ac757b68ab360187591497eeabc56a4ddb7901e4567108e44886a2011a29c2884d4b7389557826f36a6c384f4a9c69
)

set(PATCHES
    "mark-threads-private.patch"
    "fix-dependency.patch"
)

if (KMPKG_TARGET_IS_OSX AND KMPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    list(APPEND PATCHES "fix-osx-x64.patch")
endif()

if (KMPKG_TARGET_IS_WINDOWS AND KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    list(APPEND PATCHES "fix-win-arm64.patch")
endif()

if (KMPKG_TARGET_IS_ANDROID AND KMPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    list(APPEND PATCHES "fix-ndk-arm.patch")
endif()

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
        ${PATCHES}
)

if (KMPKG_TARGET_IS_ANDROID AND KMPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    kmpkg_replace_string("${SOURCE_PATH}/angelscript/source/as_callfunc_arm_gcc.S"
[[.globl armFuncObjLast       /* Make the function globally accessible.*/]]
[[.globl armFuncObjLast       /* Make the function globally accessible.*/
.type armFuncObjLast, %function]])
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/angelscript/projects/cmake"
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/Angelscript")

# Copy the addon files
if("addons" IN_LIST FEATURES)
    file(INSTALL "${SOURCE_PATH}/add_on/" DESTINATION "${CURRENT_PACKAGES_DIR}/include/angelscript" FILES_MATCHING PATTERN "*.h" PATTERN "*.cpp")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/docs/manual/doc_license.html")
