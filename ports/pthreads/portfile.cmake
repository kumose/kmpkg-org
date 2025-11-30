if(NOT KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_MINGW)
  set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
  return()
endif()

if(KMPKG_TARGET_IS_UWP)
  list(APPEND PATCH_FILES fix-uwp-linkage.patch)
  # Inject linker option using the `LINK` environment variable
  # https://docs.microsoft.com/en-us/cpp/build/reference/linker-options
  # https://docs.microsoft.com/en-us/cpp/build/reference/linking#link-environment-variables
  set(ENV{LINK} "/APPCONTAINER")
endif()

if (KMPKG_CRT_LINKAGE STREQUAL dynamic)
  list(APPEND PATCH_FILES use-md.patch)
else()
  list(APPEND PATCH_FILES use-mt.patch)
endif()

kmpkg_from_sourceforge(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO pthreads4w
  FILENAME "pthreads4w-code-v${VERSION}.zip"
  SHA512 49e541b66c26ddaf812edb07b61d0553e2a5816ab002edc53a38a897db8ada6d0a096c98a9af73a8f40c94283df53094f76b429b09ac49862465d8697ed20013
  PATCHES
    fix-arm-macro.patch
    fix-arm64-version_rc.patch # https://sourceforge.net/p/pthreads4w/code/merge-requests/6/
    fix-pthread_getname_np.patch
    fix-install.patch
    whitespace_in_path.patch
    ${PATCH_FILES}
)

file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/debug" DESTROOT_DEBUG)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" DESTROOT_RELEASE)

kmpkg_list(SET OPTIONS_DEBUG "DESTROOT=${DESTROOT_DEBUG}")
kmpkg_list(SET OPTIONS_RELEASE "DESTROOT=${DESTROOT_RELEASE}" "BUILD_RELEASE=1")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
  kmpkg_list(APPEND OPTIONS_DEBUG "BUILD_STATIC=1")
  kmpkg_list(APPEND OPTIONS_RELEASE "BUILD_STATIC=1")
endif()

kmpkg_install_nmake(
  CL_LANGUAGE C
  SOURCE_PATH "${SOURCE_PATH}"
  PROJECT_NAME Makefile
  OPTIONS_DEBUG ${OPTIONS_DEBUG}
  OPTIONS_RELEASE ${OPTIONS_RELEASE}
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/PThreads4WConfig.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/PThreads4W")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper-pthread.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/pthread" RENAME kmpkg-cmake-wrapper.cmake)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper-pthreads.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/pthreads" RENAME kmpkg-cmake-wrapper.cmake)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper-pthreads-windows.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/PThreads_windows" RENAME kmpkg-cmake-wrapper.cmake)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

set(KMPKG_POLICY_ALLOW_RESTRICTED_HEADERS enabled)
