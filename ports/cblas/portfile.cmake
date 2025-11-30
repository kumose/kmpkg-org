SET(KMPKG_POLICY_EMPTY_PACKAGE enabled)

# This block should be kept in sync with the port 'blas'
if(KMPKG_TARGET_IS_OSX OR KMPKG_TARGET_IS_IOS)
    # Use Apple's accelerate framework where available
    set(BLA_VENDOR Apple)
    set(requires "")
    set(libs "-framework Accelerate")
    set(cflags "-framework Accelerate")
elseif(KMPKG_TARGET_IS_UWP
        OR (KMPKG_TARGET_IS_WINDOWS AND KMPKG_TARGET_ARCHITECTURE MATCHES "arm")
        OR NOT KMPKG_TARGET_IS_WINDOWS
        OR NOT (KMPKG_LIBRARY_LINKAGE STREQUAL "static"))
    set(BLA_VENDOR OpenBLAS)
    set(requires openblas)
else()
    set(BLA_VENDOR Generic)
    set(requires "cblas-reference")
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/cblas.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/cblas.pc" @ONLY)
if(NOT KMPKG_BUILD_TYPE)
    configure_file("${CMAKE_CURRENT_LIST_DIR}/cblas.pc.in" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/cblas.pc" @ONLY)
endif()
