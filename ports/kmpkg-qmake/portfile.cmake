file(INSTALL
    "${CMAKE_CURRENT_LIST_DIR}/kmpkg_qmake_configure.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/kmpkg_qmake_build.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/kmpkg_qmake_install.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/z_kmpkg_qmake_fix_makefiles.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/kmpkg-port-config.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(INSTALL "${KMPKG_ROOT_DIR}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
set(KMPKG_POLICY_CMAKE_HELPER_PORT enabled)
