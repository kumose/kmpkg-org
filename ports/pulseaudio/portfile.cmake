kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pulseaudio/pulseaudio
    REF "v${VERSION}"
    SHA512  84b5218dca3a6f793eec5427606a09cabcf108a2aad8316c15422c130d76d1ed6de14e93549c6d952e4f33bcd1e7621d30ebaa145986a5e6fc890e0655c00e07
    HEAD_REF master
)

file(WRITE "${SOURCE_PATH}/.tarball-version" "${VERSION}")
file(REMOVE "${SOURCE_PATH}/git-version-gen")
kmpkg_replace_string ("${SOURCE_PATH}/meson.build"
  "run_command(find_program('git-version-gen'), join_paths(meson.current_source_dir(), '.tarball-version'), check : false).stdout().strip()" 
  "'${VERSION}'")

set(opts "")
if(KMPKG_TARGET_IS_LINUX)
  list(APPEND opts
    -Dalsa=enabled
    -Doss-output=enabled
  )
else()
  list(APPEND opts
    -Dalsa=disabled
    -Doss-output=disabled
  )
endif()
if("gstreamer" IN_LIST FEATURES)
  list(APPEND opts -Dgstreamer=enabled)
else()
  list(APPEND opts -Dgstreamer=disabled)
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      ${opts}
      -Ddaemon=false
      -Dclient=true
      -Ddoxygen=false
      -Dgcov=false
      -Dman=false
      -Dtests=false
      -Dbashcompletiondir=no
      -Dzshcompletiondir=no
      
      -Dasyncns=disabled # requires port?
      -Davahi=disabled
      -Dbluez5=disabled
      -Dconsolekit=disabled
      -Ddbus=enabled
      -Delogind=disabled
      -Dfftw=enabled
      -Dglib=enabled
      -Dgsettings=disabled
      -Dgtk=disabled
      -Dhal-compat=false
      -Dipv6=true
      -Djack=enabled # jack2?
      -Dlirc=enabled # does this need a port?
      -Dopenssl=enabled
      -Dorc=disabled # not port orc

      -Dsoxr=enabled
      -Dspeex=enabled
      -Dsystemd=disabled
      -Dtcpwrap=disabled
      -Dudev=disabled # port ?
      -Dvalgrind=disabled
      -Dx11=disabled
      
      -Dadrian-aec=false
      -Dwebrtc-aec=disabled
)


kmpkg_replace_string("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/config.h" "${CURRENT_PACKAGES_DIR}" "~~invalid~~")
kmpkg_replace_string("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/config.h" "${SOURCE_PATH}" "~~invalid~~")
if(NOT KMPKG_BUILD_TYPE)
  kmpkg_replace_string("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/config.h" "${CURRENT_PACKAGES_DIR}/debug" "~~invalid~~")
  kmpkg_replace_string("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/config.h" "${SOURCE_PATH}" "~~invalid~~")
endif()

kmpkg_install_meson()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/PulseAudio")

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/bin/padsp" "${CURRENT_PACKAGES_DIR}" [[$(dirname "$0")/../..]])
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/etc/pulse/client.conf" "${CURRENT_PACKAGES_DIR}" "<path-to-pulseaudio>")
if(NOT KMPKG_BUILD_TYPE)
  kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/etc/pulse/client.conf" "${CURRENT_PACKAGES_DIR}" "<path-to-pulseaudio>")
endif()
kmpkg_copy_tools(TOOL_NAMES pacat pactl padsp pa-info pamon AUTO_CLEAN)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
