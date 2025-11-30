if(KMPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "No implementation of getopt is currently available for UWP targets")
endif()

set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
