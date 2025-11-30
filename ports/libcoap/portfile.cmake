# dllexport is not supported.
if(KMPKG_TARGET_IS_WINDOWS)
  kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_download_distfile(DLLEXPORT_PATCH
    URLS https://github.com/obgm/libcoap/commit/0bd03b658ed2d75fdb7cb8f6add201b39b428298.patch?full_index=1
    FILENAME obgm-remove-self-configure-file-0bd03b658ed2d75fdb7cb8f6add201b39b428298.patch
    SHA512 6c120dc278a5d73d0b9bd2f66468c822ccde80513262201119cdceb9ed6fdf2f84d473926373f18ef69d709d4e95212e484079072a52d5c65d09e4ccb82368e5
)

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO obgm/libcoap
  REF v4.3.5
  SHA512 21332f4988c83cc3e26a70db6f2c3028e75fabc7990238d3c13666c5725674231799e147427b0fa827cf6c9e4d9f03d5176129f69425e2439ade13ea82267c05
  HEAD_REF main
  PATCHES
      "${DLLEXPORT_PATCH}"
      remove-hardcoded-tinydtls-path.patch)

kmpkg_check_features(
  OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
      examples ENABLE_EXAMPLES
      dtls     ENABLE_DTLS
)

kmpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
      ${FEATURE_OPTIONS}
      -DENABLE_DOCS=OFF
      -DDTLS_BACKEND=openssl)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/libcoap")

if("examples" IN_LIST FEATURES)
  kmpkg_copy_tools(
      TOOL_NAMES coap-client coap-rd coap-server
      AUTO_CLEAN
  )
  # Same condition in licoap/CMakeLists.txt
  if(NOT KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    kmpkg_copy_tools(
        TOOL_NAMES etsi_iot_01 tiny oscore-interop-server
        AUTO_CLEAN
    )
  endif()
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
