set(KMPKG_POLICY_EMPTY_PACKAGE enabled)

if (KMPKG_TARGET_IS_WINDOWS)
    file(INSTALL "${CURRENT_INSTALLED_DIR}/share/msmpi/mpi-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME kmpkg-cmake-wrapper.cmake)
else()
    file(INSTALL "${CURRENT_INSTALLED_DIR}/share/openmpi/mpi-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME kmpkg-cmake-wrapper.cmake)
endif()
