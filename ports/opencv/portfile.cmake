SET(KMPKG_POLICY_EMPTY_PACKAGE enabled)

set(USE_OPENCV_VERSION "4")
configure_file("${CURRENT_PORT_DIR}/kmpkg-cmake-wrapper.cmake.in" "${CURRENT_PACKAGES_DIR}/share/opencv/kmpkg-cmake-wrapper.cmake" @ONLY)
