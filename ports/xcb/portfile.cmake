if(NOT X_KMPKG_FORCE_KMPKG_X_LIBRARIES AND NOT KMPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force kmpkg libraries by setting X_KMPKG_FORCE_KMPKG_X_LIBRARIES in your triplet")
    set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
else()

kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxcb
    REF  ddafdba11f6919e6fcf977c09c78b06f94de47aa #v1.14 + some patches
    SHA512 d8382b04f2b00671cded9e22d6066164511ee4c08e2cf5de4ec28d09e41228e30d3ba7d0e6b5141abf4e4bc777aa662fe9d1d04f3e1e26e0b323549e845c8072
    HEAD_REF master
    PATCHES makefile.patch # without the patch target xproto.c is missing target XCBPROTO_XCBINCLUDEDIR
            configure.patch 
            use_xwindows_includes.patch # use the X11 include wrappers for windows headers
            getpid_include.patch # add include for getpid on windows
            win-fixes.patch # avoid: 'close' undefined; assuming extern returning int
) 

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")
if(KMPKG_TARGET_IS_WINDOWS)
    set(OPTIONS --disable-dependency-tracking)
endif()

kmpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
file(TO_NATIVE_PATH "${PYTHON3_DIR}" PYTHON3_DIR_NATIVE)
kmpkg_add_to_path("${PYTHON3_DIR}")

if(NOT XLSTPROC)
    find_program(XLSTPROC NAMES "xsltproc${KMPKG_HOST_EXECUTABLE_SUFFIX}" PATHS "${CURRENT_HOST_INSTALLED_DIR}/tools/libxslt" PATH_SUFFIXES "bin")
endif()
if(NOT XLSTPROC)
    message(FATAL_ERROR "${PORT} requires xlstproc for the host system. Please install libxslt within kmpkg or your system package manager!")
endif()
get_filename_component(XLSTPROC_DIR "${XLSTPROC}" DIRECTORY)
file(TO_NATIVE_PATH "${XLSTPROC_DIR}" XLSTPROC_DIR_NATIVE)
kmpkg_add_to_path("${XLSTPROC_DIR}")
set(ENV{XLSTPROC} "${XLSTPROC}")

if(DEFINED ENV{PYTHONPATH})
    set(ENV{PYTHONPATH} "${CURRENT_INSTALLED_DIR}/tools/python3/site-packages/${KMPKG_HOST_PATH_SEPARATOR}$ENV{PYTHONPATH}")
else()
    set(ENV{PYTHONPATH} "${CURRENT_INSTALLED_DIR}/tools/python3/site-packages/")
endif()

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS ${OPTIONS}
)

kmpkg_install_make()

set(pcfile "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/xcb.pc")
if(EXISTS "${pcfile}")
    kmpkg_replace_string("${pcfile}" "Requires: " "Requires: xau xdmcp " IGNORE_UNCHANGED)
endif()
set(pcfile "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/xcb.pc")
if(EXISTS "${pcfile}")
    kmpkg_replace_string("${pcfile}" "Requires: " "Requires: xau xdmcp " IGNORE_UNCHANGED)
endif()

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

if(KMPKG_TARGET_IS_WINDOWS AND KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic" AND NOT KMPKG_TARGET_IS_MINGW)
    set(extensions 
            bigreq 
            composite
            damage
            dpms
            dri2
            dri3
            ge
            glx
            present
            randr
            record
            render
            res
            screensaver
            shape
            shm
            sync
            xc_misc
            xevie
            xf86dri
            xfixes
            xinerama
            xinput
            xkb
            xprint
            xtest
            xv
            xvmc)
    foreach(ext IN LISTS extensions)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/xcb/${ext}.h"
                     "extern xcb_extension_t"
                     "__declspec(dllimport) extern xcb_extension_t")
    endforeach()
endif()
endif()
