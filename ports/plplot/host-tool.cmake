if(NOT TARGET @name@)
    add_executable(@name@ IMPORTED)
    set_target_properties(@name@ PROPERTIES
        IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/@name@@KMPKG_TARGET_EXECUTABLE_SUFFIX@"
    )
endif()
