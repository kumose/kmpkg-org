set(KMPKG_POLICY_EMPTY_PACKAGE enabled)

set(key NOTFOUND)
if(KMPKG_CMAKE_SYSTEM_NAME)
    set(key "${KMPKG_CMAKE_SYSTEM_NAME}-${KMPKG_TARGET_ARCHITECTURE}")
elseif(KMPKG_TARGET_IS_WINDOWS)
    set(key "Windows-${KMPKG_TARGET_ARCHITECTURE}")
endif()

kmpkg_download_distfile(license
	URLS "https://github.com/tree-sitter/tree-sitter/raw/refs/tags/v${VERSION}/LICENSE"
	FILENAME "tree-sitter-v${VERSION}-LICENSE"
	SHA512 50781942281117c409cd4fe79b18314bf26560107e13539bfd8f1e5ded538ab7e00b8e7e665dbc6acb69a6ca524d1a3a5ef2fb3d0156aa0984f68c178d6aeb6e
)

set(archive_path NOTFOUND)
# For convenient updates, use 
# kmpkg install tree-sitter-cli --cmake-args=-DKMPKG_TREE_SITTER_UPDATE=1
if(key STREQUAL "Linux-arm64" OR KMPKG_TREE_SITTER_UPDATE)
    set(filename "tree-sitter-${VERSION}-linux-arm64.gz")
    kmpkg_download_distfile(archive_path
        URLS "https://github.com/tree-sitter/tree-sitter/releases/download/v${VERSION}/tree-sitter-linux-arm64.gz"
        FILENAME "${filename}"
        SHA512 749578d0d9928ae0da5b030df67e76bd548623cda1317316ac6c2a9025ae1c0d5ca2843e88b10b9b900dc39419099a4234ad67fd93b422a4f9a280f80523a47e
    )
endif()
if(key STREQUAL "Linux-x64" OR KMPKG_TREE_SITTER_UPDATE)
    set(filename "tree-sitter-${VERSION}-linux-x64.gz")
    kmpkg_download_distfile(archive_path
        URLS "https://github.com/tree-sitter/tree-sitter/releases/download/v${VERSION}/tree-sitter-linux-x64.gz"
        FILENAME "${filename}"
        SHA512 29f9b5890338d9b37adaa2112daabe66dca999a5bbc1e47853481fcd388c0676b38d6134dab614e683c0b9c793f1b8036f09999abbc744a9ccecdbdf4943873b
    )
endif()
if(key STREQUAL "Darwin-arm64" OR KMPKG_TREE_SITTER_UPDATE)
    set(filename "tree-sitter-${VERSION}-macos-arm64.gz")
    kmpkg_download_distfile(archive_path
        URLS "https://github.com/tree-sitter/tree-sitter/releases/download/v${VERSION}/tree-sitter-macos-arm64.gz"
        FILENAME "${filename}"
        SHA512 393580273793c8d376aea46ea2f73f224e442729b89985541371986123f1dc396e70310ab3eb213ae8eb1432633c3605d228296aac2545bd269583ef103949f2
    )
    # Avoid breaking the code signature.
    set(KMPKG_FIXUP_MACHO_RPATH OFF)
endif()
if(key STREQUAL "Darwin-x64" OR KMPKG_TREE_SITTER_UPDATE)
    set(filename "tree-sitter-${VERSION}-macos-x64.gz")
    kmpkg_download_distfile(archive_path
        URLS "https://github.com/tree-sitter/tree-sitter/releases/download/v${VERSION}/tree-sitter-macos-x64.gz"
        FILENAME "${filename}"
        SHA512 5d9267b02b254377a508685ee3b522c5f186cc65aae4ae2d0099effeb3a8296a208e97fbf0fec77cd75b0c6427bc3d27beafd83bfe4776ec3345b87cd088c687
    )
    # Avoid breaking the code signature.
    set(KMPKG_FIXUP_MACHO_RPATH OFF)
endif()
if(key STREQUAL "Windows-arm64" OR KMPKG_TREE_SITTER_UPDATE)
    set(filename "tree-sitter-${VERSION}-windows-arm64.gz")
    kmpkg_download_distfile(archive_path
        URLS "https://github.com/tree-sitter/tree-sitter/releases/download/v${VERSION}/tree-sitter-windows-arm64.gz"
        FILENAME "${filename}"
        SHA512 07a2b8e0f2325b83e543e76a2ff4f248c230bad51486f870b1c0e856bca9aa4ac04d70b66535ef517bfa184b55081b3b5a78b07532a3ae750195579f45621d6d
    )
endif()
if(key STREQUAL "Windows-x64" OR KMPKG_TREE_SITTER_UPDATE)
    set(filename "tree-sitter-${VERSION}-windows-x64.gz")
    kmpkg_download_distfile(archive_path
        URLS "https://github.com/tree-sitter/tree-sitter/releases/download/v${VERSION}/tree-sitter-windows-x64.gz"
        FILENAME "${filename}"
        SHA512 dd51eef2b0ca9d372ed0b66acb9b079a46a623adccffd1af40bbad9330b8caac71716f6163a98f6972ca26be1254978dc22b843b9b827a7420e074b8789d7f7e
    )
endif()
if(NOT archive_path)
    message(FATAL_ERROR "Unsupported platform '${key}'. Please implement me!")
endif()

if(KMPKG_TREE_SITTER_UPDATE)
    message(STATUS "All downloads are up-to-date.")
    message(FATAL_ERROR "Stopping due to KMPKG_TREE_SITTER_UPDATE being enabled.")
endif()

file(COPY "${archive_path}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
cmake_path(GET archive_path FILENAME archive_name)
set(gunzip_command_line gunzip "${archive_name}")
if(CMAKE_HOST_WIN32)
    kmpkg_acquire_msys(MSYS_ROOT)
    kmpkg_host_path_list(APPEND ENV{PATH} "${MSYS_ROOT}/usr/bin")
	set(gunzip_command_line sh -c "gunzip '${archive_name}'")
endif()
kmpkg_execute_required_process(
    ALLOW_IN_DOWNLOAD_MODE
    COMMAND ${gunzip_command_line}
    WORKING_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}"
    LOGNAME "gunzip-${TARGET_TRIPLET}"
)
string(REGEX REPLACE "[.]gz\$" "" tool_name "${archive_name}")
file(RENAME "${CURRENT_PACKAGES_DIR}/tools/${PORT}/${tool_name}" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/tree-sitter${KMPKG_HOST_EXECUTABLE_SUFFIX}")
file(CHMOD "${CURRENT_PACKAGES_DIR}/tools/${PORT}/tree-sitter${KMPKG_HOST_EXECUTABLE_SUFFIX}"
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)

kmpkg_install_copyright(FILE_LIST "${license}"
	COMMENT [[
Tree-sitter is licensed under the MIT license. The tree-sitter CLI uses
third-party components which are not listed individually here.
]])
