#[===[.md:
# kmpkg_qmake_install

Build and install a qmake project.

## Usage:
```cmake
kmpkg_qmake_install(...)
```

## Parameters:
See [`kmpkg_qmake_build()`](kmpkg_qmake_build.md).

## Notes:
This command transparently forwards to [`kmpkg_qmake_build()`](kmpkg_qmake_build.md).
and appends the 'install' target

#]===]

function(z_kmpkg_qmake_fix_prl PACKAGE_DIR PRL_FILES)
        file(TO_CMAKE_PATH "${PACKAGE_DIR}/lib" CMAKE_LIB_PATH)
        file(TO_CMAKE_PATH "${PACKAGE_DIR}/include/Qt6" CMAKE_INCLUDE_PATH_QT6)
        file(TO_CMAKE_PATH "${PACKAGE_DIR}/include" CMAKE_INCLUDE_PATH)
        file(TO_CMAKE_PATH "${CURRENT_INSTALLED_DIR}" CMAKE_INSTALLED_PREFIX)
        foreach(PRL_FILE IN LISTS PRL_FILES)
            file(READ "${PRL_FILE}" _contents)
            string(REPLACE "${CMAKE_LIB_PATH}" "\$\$[QT_INSTALL_LIBS]" _contents "${_contents}")
            string(REPLACE "${CMAKE_INCLUDE_PATH_QT6}" "\$\$[QT_INSTALL_HEADERS]" _contents "${_contents}")
            string(REPLACE "${CMAKE_INCLUDE_PATH}" "\$\$[QT_INSTALL_HEADERS]/../" _contents "${_contents}")
            string(REPLACE "${CMAKE_INSTALLED_PREFIX}" "\$\$[QT_INSTALL_PREFIX]" _contents "${_contents}")
            string(REGEX REPLACE "QMAKE_PRL_BUILD_DIR[^\\\n]+" "QMAKE_PRL_BUILD_DIR =" _contents "${_contents}")
            #Note: This only works without an extra if case since QT_INSTALL_PREFIX is the same for debug and release
            file(WRITE "${PRL_FILE}" "${_contents}")
        endforeach()
endfunction()

function(kmpkg_qmake_install)
    z_kmpkg_function_arguments(args)
    kmpkg_qmake_build(${args})
    kmpkg_qmake_build(SKIP_MAKEFILES BUILD_LOGNAME "install" TARGETS "install")

    # Fix absolute paths in prl files
    file(GLOB_RECURSE prl_files "${CURRENT_PACKAGES_DIR}/**.prl")
    debug_message(STATUS "prl_files:${prl_files}")
    z_kmpkg_qmake_fix_prl("${CURRENT_PACKAGES_DIR}" "${prl_files}")
endfunction()
