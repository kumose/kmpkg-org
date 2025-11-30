set(KMPKG_POLICY_EMPTY_PACKAGE enabled)

configure_file("${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" "${CURRENT_PACKAGES_DIR}/share/egl/kmpkg-cmake-wrapper.cmake" @ONLY)

if(KMPKG_TARGET_IS_WINDOWS)
    configure_file("${CMAKE_CURRENT_LIST_DIR}/egl.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/egl.pc" @ONLY)
    if (NOT KMPKG_BUILD_TYPE)
        configure_file("${CMAKE_CURRENT_LIST_DIR}/egl.pc.in" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/egl.pc" @ONLY)
    endif()
    kmpkg_fixup_pkgconfig()
endif()
