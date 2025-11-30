include_guard(GLOBAL)

function(kmpkg_qmake_configure)
    cmake_parse_arguments(PARSE_ARGV 0 arg "" "SOURCE_PATH" "QMAKE_OPTIONS;QMAKE_OPTIONS_RELEASE;QMAKE_OPTIONS_DEBUG;OPTIONS;OPTIONS_RELEASE;OPTIONS_DEBUG")

    kmpkg_cmake_get_vars(detected_file)
    include("${detected_file}")

    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        kmpkg_list(APPEND arg_QMAKE_OPTIONS "CONFIG-=shared")
        kmpkg_list(APPEND arg_QMAKE_OPTIONS "CONFIG*=static")
    else()
        kmpkg_list(APPEND arg_QMAKE_OPTIONS "CONFIG-=static")
        kmpkg_list(APPEND arg_QMAKE_OPTIONS "CONFIG*=shared")
        kmpkg_list(APPEND arg_QMAKE_OPTIONS_DEBUG "CONFIG*=separate_debug_info")
    endif()
    if(KMPKG_TARGET_IS_WINDOWS AND KMPKG_CRT_LINKAGE STREQUAL "static")
        kmpkg_list(APPEND arg_QMAKE_OPTIONS "CONFIG*=static-runtime")
    endif()

    set(ENV{PKG_CONFIG} "${CURRENT_HOST_INSTALLED_DIR}/tools/pkgconf/pkgconf${KMPKG_HOST_EXECUTABLE_SUFFIX}")
    get_filename_component(PKGCONFIG_PATH "${PKGCONFIG}" DIRECTORY)
    kmpkg_add_to_path("${PKGCONFIG_PATH}")

    set(buildtypes "")
    if(NOT KMPKG_BUILD_TYPE OR "${KMPKG_BUILD_TYPE}" STREQUAL "debug")
        list(APPEND buildtypes "DEBUG") # Using uppercase to also access the detected cmake variables with it
        set(path_suffix_DEBUG "debug/")
        set(short_name_DEBUG "dbg")
        set(qmake_config_DEBUG CONFIG+=debug CONFIG-=release)
    endif()
    if(NOT KMPKG_BUILD_TYPE OR "${KMPKG_BUILD_TYPE}" STREQUAL "release")
        list(APPEND buildtypes "RELEASE")
        set(path_suffix_RELEASE "")
        set(short_name_RELEASE "rel")
        set(qmake_config_RELEASE CONFIG-=debug CONFIG+=release)
    endif()

    function(qmake_append_program var qmake_var value)
        # Danger zone: qmake poorly handles tools in C:/Program Files etc.
        # IOW for MSVC it expects short command names, found via PATH.
        if(value MATCHES " ")
            get_filename_component(prog "${value}" NAME)
            find_program("z_kmpkg_qmake_${qmake_var}" NAMES "${prog}" PATHS ENV PATH NO_DEFAULT_PATH NO_CACHE)
            cmake_path(COMPARE "${z_kmpkg_qmake_${qmake_var}}" EQUAL "${value}" expected_program_in_path)
            if(NOT expected_program_in_path)
                message(FATAL_ERROR
                    "Detected path mismatch for '${qmake_var}=${prog}'.\n"
                    "  Actual:   ${z_kmpkg_qmake_${qmake_var}}\n"
                    "  Expected: ${value}\n"
                    "Please correct environment variable PATH!"
                )
            endif()
        else()
            set(prog "${value}")
        endif()
        kmpkg_list(APPEND "${var}" "${qmake_var}=${prog}")
        set("${var}" "${${var}}" PARENT_SCOPE)
    endfunction()
    # Setup Build tools
    if(NOT KMPKG_QMAKE_COMMAND) # For users using outside Qt6
        set(KMPKG_QMAKE_COMMAND "${CURRENT_HOST_INSTALLED_DIR}/tools/Qt6/bin/qmake${KMPKG_HOST_EXECUTABLE_SUFFIX}")
    endif()

    if(KMPKG_TARGET_IS_OSX)
        # Get Qt version
        execute_process(
            COMMAND ${KMPKG_QMAKE_COMMAND} -query QT_VERSION
            OUTPUT_VARIABLE QT_VERSION
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        if(DEFINED KMPKG_OSX_DEPLOYMENT_TARGET)
            kmpkg_list(APPEND arg_QMAKE_OPTIONS "QMAKE_MACOSX_DEPLOYMENT_TARGET=${KMPKG_OSX_DEPLOYMENT_TARGET}")
        elseif(${QT_VERSION} VERSION_GREATER_EQUAL 6)
            # https://doc.qt.io/qt-6/macos.html
            kmpkg_list(APPEND arg_QMAKE_OPTIONS "QMAKE_MACOSX_DEPLOYMENT_TARGET=10.15")
        else() # Qt5
            # https://doc.qt.io/qt-5/macos.html
            kmpkg_list(APPEND arg_QMAKE_OPTIONS "QMAKE_MACOSX_DEPLOYMENT_TARGET=10.13")
        endif()
    endif()

    set(qmake_build_tools "")
    qmake_append_program(qmake_build_tools "QMAKE_CC" "${KMPKG_DETECTED_CMAKE_C_COMPILER}")
    qmake_append_program(qmake_build_tools "QMAKE_CXX" "${KMPKG_DETECTED_CMAKE_CXX_COMPILER}")
    qmake_append_program(qmake_build_tools "QMAKE_AR" "${KMPKG_DETECTED_CMAKE_AR}")
    qmake_append_program(qmake_build_tools "QMAKE_RANLIB" "${KMPKG_DETECTED_CMAKE_RANLIB}")
    qmake_append_program(qmake_build_tools "QMAKE_STRIP" "${KMPKG_DETECTED_CMAKE_STRIP}")
    qmake_append_program(qmake_build_tools "QMAKE_NM" "${KMPKG_DETECTED_CMAKE_NM}")
    qmake_append_program(qmake_build_tools "QMAKE_RC" "${KMPKG_DETECTED_CMAKE_RC_COMPILER}")
    qmake_append_program(qmake_build_tools "QMAKE_MT" "${KMPKG_DETECTED_CMAKE_MT}")

    if(NOT KMPKG_TARGET_IS_WINDOWS OR KMPKG_DETECTED_CMAKE_AR MATCHES "ar$")
        kmpkg_list(APPEND qmake_build_tools "QMAKE_AR+=qc")
    endif()

    if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
        qmake_append_program(qmake_build_tools "QMAKE_LIB" "${KMPKG_DETECTED_CMAKE_AR}")
        qmake_append_program(qmake_build_tools "QMAKE_LINK" "${KMPKG_DETECTED_CMAKE_LINKER}")
    else()
        qmake_append_program(qmake_build_tools "QMAKE_LINK" "${KMPKG_DETECTED_CMAKE_CXX_COMPILER}")
        qmake_append_program(qmake_build_tools "QMAKE_LINK_SHLIB" "${KMPKG_DETECTED_CMAKE_CXX_COMPILER}")
        qmake_append_program(qmake_build_tools "QMAKE_LINK_C" "${KMPKG_DETECTED_CMAKE_C_COMPILER}")
        qmake_append_program(qmake_build_tools "QMAKE_LINK_C_SHLIB" "${KMPKG_DETECTED_CMAKE_C_COMPILER}")
    endif()

    if(DEFINED KMPKG_QT_TARGET_MKSPEC)
        kmpkg_list(APPEND arg_QMAKE_OPTIONS "-spec" "${KMPKG_QT_TARGET_MKSPEC}")
    endif()

    foreach(buildtype IN LISTS buildtypes)
        set(short "${short_name_${buildtype}}")
        string(TOLOWER "${buildtype}" lowerbuildtype)
        set(prefix "${CURRENT_INSTALLED_DIR}${path_suffix_${buildtype}}")
        set(prefix_package "${CURRENT_PACKAGES_DIR}${path_suffix_${buildtype}}")
        set(config_triplet "${TARGET_TRIPLET}-${short}")
        # Cleanup build directories
        file(REMOVE_RECURSE "${CURRENT_BUILDTREES_DIR}/${config_triplet}")

        set(qmake_comp_flags "")
        macro(qmake_add_flags qmake_var operation flags)
            string(STRIP "${flags}" striped_flags)
            if(striped_flags)
                kmpkg_list(APPEND qmake_comp_flags "${qmake_var}${operation}${striped_flags}")
            endif()
        endmacro()
        
        qmake_add_flags("QMAKE_LIBS" "+=" "${KMPKG_DETECTED_CMAKE_C_STANDARD_LIBRARIES} ${KMPKG_DETECTED_CMAKE_CXX_STANDARD_LIBRARIES}")
        qmake_add_flags("QMAKE_RC" "+=" "${KMPKG_COMBINED_RC_FLAGS_${buildtype}}") # not exported by kmpkg_cmake_get_vars yet
        qmake_add_flags("QMAKE_CFLAGS_${buildtype}" "+=" "${KMPKG_COMBINED_C_FLAGS_${buildtype}}")
        qmake_add_flags("QMAKE_CXXFLAGS_${buildtype}" "+=" "${KMPKG_COMBINED_CXX_FLAGS_${buildtype}}")
        qmake_add_flags("QMAKE_LFLAGS" "+=" "${KMPKG_COMBINED_STATIC_LINKER_FLAGS_${buildtype}}")
        qmake_add_flags("QMAKE_LFLAGS_SHLIB" "+=" "${KMPKG_COMBINED_SHARED_LINKER_FLAGS_${buildtype}}")
        qmake_add_flags("QMAKE_LFLAGS_PLUGIN" "+=" "${KMPKG_COMBINED_MODULE_LINKER_FLAGS_${buildtype}}")
        qmake_add_flags("QMAKE_LIBFLAGS" "+=" "${KMPKG_COMBINED_STATIC_LINKER_FLAGS_${buildtype}}")
        qmake_add_flags("QMAKE_LIBFLAGS_${buildtype}" "+=" "${KMPKG_COMBINED_STATIC_LINKER_FLAGS_${buildtype}}")
        kmpkg_list(APPEND qmake_build_tools "QMAKE_AR+=${KMPKG_COMBINED_STATIC_LINKER_FLAGS_${buildtype}}")

        # QMAKE_CXXFLAGS_SHLIB

        # Setup qt.conf
        if(NOT KMPKG_QT_CONF_${buildtype})
            set(KMPKG_QT_CONF_${buildtype} "${CURRENT_INSTALLED_DIR}/tools/Qt6/qt_${lowerbuildtype}.conf")
        else()
            # Let a supplied qt.conf override everything.
            # The file will still be configured so users might use the variables within this scope.
            set(qmake_build_tools "") 
            set(qmake_comp_flags "")
        endif()
        configure_file("${KMPKG_QT_CONF_${buildtype}}" "${CURRENT_BUILDTREES_DIR}/${config_triplet}/qt.conf")

        kmpkg_backup_env_variables(VARS PKG_CONFIG_PATH)
        kmpkg_host_path_list(PREPEND PKG_CONFIG_PATH "${prefix}/lib/pkgconfig" "${CURRENT_INSTALLED_DIR}/share/pkgconfig")

        message(STATUS "Configuring ${config_triplet}")
        if(DEFINED arg_OPTIONS OR DEFINED arg_OPTIONS_${buildtype})
            set(options -- ${arg_OPTIONS} ${arg_OPTIONS_${buildtype}})
        endif()
        # Options might need to go into a response file? I am a bit concerned about cmd line length. 
        kmpkg_execute_required_process(
            COMMAND ${KMPKG_QMAKE_COMMAND} ${qmake_config_${buildtype}}
                    ${arg_QMAKE_OPTIONS} ${arg_QMAKE_OPTIONS_${buildtype}}
                    ${KMPKG_QMAKE_OPTIONS} ${KMPKG_QMAKE_OPTIONS_${buildtype}} # Advanced users need a way to inject QMAKE variables via the triplet.
                    ${qmake_build_tools} ${qmake_comp_flags}
                    "${arg_SOURCE_PATH}"
                    -qtconf "${CURRENT_BUILDTREES_DIR}/${config_triplet}/qt.conf"
                    ${options}
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${config_triplet}"
            LOGNAME config-${config_triplet}
            SAVE_LOG_FILES config.log
        )
        z_kmpkg_qmake_fix_makefiles("${CURRENT_BUILDTREES_DIR}/${config_triplet}")
        message(STATUS "Configuring ${config_triplet} done")

        kmpkg_restore_env_variables(VARS PKG_CONFIG_PATH)
        if(EXISTS "${CURRENT_BUILDTREES_DIR}/${config_triplet}/config.log")
            file(REMOVE "${CURRENT_BUILDTREES_DIR}/internal-config-${config_triplet}.log")
            file(RENAME "${CURRENT_BUILDTREES_DIR}/${config_triplet}/config.log" "${CURRENT_BUILDTREES_DIR}/internal-config-${config_triplet}.log")
        endif()
    endforeach()
endfunction()