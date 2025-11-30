file(INSTALL
    "${CMAKE_CURRENT_LIST_DIR}/kmpkg-port-config.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright" "")

set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
