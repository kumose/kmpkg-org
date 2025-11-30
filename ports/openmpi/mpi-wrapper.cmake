if(NOT DEFINED MPI_HOME)
    set(MPI_HOME "${KMPKG_INSTALLED_DIR}/${KMPKG_TARGET_TRIPLET}" CACHE INTERNAL "kmpkg")
    set(z_kmpkg_mpiexec_directories
        "${MPI_HOME}/tools/openmpi/bin"
        "${MPI_HOME}/tools/openmpi/debug/bin"
    )
    if(NOT DEFINED CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$")
        list(REVERSE z_kmpkg_mpiexec_directories)
    endif()
    find_program(MPIEXEC_EXECUTABLE NAMES mpiexec PATHS ${z_kmpkg_mpiexec_directories} NO_DEFAULT_PATH)
    unset(z_kmpkg_mpiexec_directories)
endif()
_find_package(${ARGS})
