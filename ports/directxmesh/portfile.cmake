set(DIRECTXMESH_TAG oct2025)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/DirectXMesh
    REF ${DIRECTXMESH_TAG}
    SHA512 bc5f2e399e09c792ae4859698dddb6debb9ce7c5a96cd3b368511529bd24272e20c8bc889523b401198556b5a3fb40e09904d5316de27317d87e36c785fbfec7
    HEAD_REF main
)

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        dx12 BUILD_DX12
        spectre ENABLE_SPECTRE_MITIGATION
        tools BUILD_TOOLS
)

if (KMPKG_HOST_IS_LINUX)
    message(WARNING "Build ${PORT} requires GCC version 9 or later")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH share/directxmesh)

if("tools" IN_LIST FEATURES)

  file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/directxmesh/")

  if(KMPKG_TARGET_ARCHITECTURE STREQUAL x64)

    kmpkg_download_distfile(
      MESHCONVERT_EXE
      URLS "https://github.com/Microsoft/DirectXMesh/releases/download/${DIRECTXMESH_TAG}/meshconvert.exe"
      FILENAME "meshconvert-${DIRECTXMESH_TAG}.exe"
      SHA512 3240fbf63c6349b2fa1f2806ea0ab789edae1abe4c48a553c7f77796b2cdc08e5c4078f05936ea18bebd9482e7753ed6fb9adfe9dce06da8c9e90aaa7ede4c9e
    )

    file(INSTALL
      "${MESHCONVERT_EXE}"
      DESTINATION "${CURRENT_PACKAGES_DIR}/tools/directxmesh/")

    file(RENAME "${CURRENT_PACKAGES_DIR}/tools/directxmesh/meshconvert-${DIRECTXMESH_TAG}.exe" "${CURRENT_PACKAGES_DIR}/tools/directxmesh/meshconvert.exe")

  elseif((KMPKG_TARGET_ARCHITECTURE STREQUAL arm64) OR (KMPKG_TARGET_ARCHITECTURE STREQUAL arm64ec))

    kmpkg_download_distfile(
      MESHCONVERT_EXE
      URLS "https://github.com/Microsoft/DirectXMesh/releases/download/${DIRECTXMESH_TAG}/meshconvert_arm64.exe"
      FILENAME "meshconvert-${DIRECTXMESH_TAG}-arm64.exe"
      SHA512 c3267992f5796f9d924120f1e84ba75322a3a373b2e8dc25e427cb8a8d79483139709c95b63431f54963ec97bdb9044782c52141e6ac25a3b87b99c3a139d4ad
    )

    file(INSTALL
      "${MESHCONVERT_EXE}"
      DESTINATION "${CURRENT_PACKAGES_DIR}/tools/directxmesh/")

    file(RENAME "${CURRENT_PACKAGES_DIR}/tools/directxmesh/meshconvert-${DIRECTXMESH_TAG}-arm64.exe" "${CURRENT_PACKAGES_DIR}/tools/directxmesh/meshconvert.exe")

  else()

    kmpkg_copy_tools(
          TOOL_NAMES meshconvert
          SEARCH_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin"
      )

  endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
