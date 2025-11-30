# Provide variables to use lib ltldl with autoconf.
#
# - <PREFIX>_LIBTOOLIZE
#   A libtoolize (wrapper) which disables the check for  libltdl.la.
#   la files are removed from packages in kmpkg (and in most distros).
#   They add little value in modern environments, and they use absolute paths.
# - <PREFIX>_OPTIONS_RELEASE,
#   <PREFIX>_OPTIONS_DEBUG:
#   Options to pass to kmpkg_make_configure.
#
# Usage:
#   kmpkg_libltdl_get_vars(LIBLTDL)
#   set(ENV{LIBTOOLIZE} "${LIBLTDL_LIBTOOLIZE}")
#   
#   kmpkg_make_configure(
#       SOURCE_PATH "${SOURCE_PATH}"
#       AUTORECONF
#       OPTIONS_RELEASE
#           ${LIBLTDL_OPTIONS_RELEASE}
#       OPTIONS_DEBUG
#           ${LIBLTDL_OPTIONS_RELEASE}
#   )

function(kmpkg_libltdl_get_vars prefix)
    # Forward libtoolize from environment to libtoolize-ltdl-no-la.
    if(NOT "$ENV{LIBTOOLIZE}" STREQUAL "")
        set(ENV{KMPKG_LIBLTDL_LIBTOOLIZE} "$ENV{LIBTOOLIZE}")
    endif()

    kmpkg_list(SET options_release
        "--with-included-ltdl=no"
        "--with-ltdl-include=${CURRENT_INSTALLED_DIR}/include"
        "--with-ltdl-lib=${CURRENT_INSTALLED_DIR}/lib"
    )
    kmpkg_list(SET options_debug
        "--with-included-ltdl=no"
        "--with-ltdl-include=${CURRENT_INSTALLED_DIR}/include"
        "--with-ltdl-lib=${CURRENT_INSTALLED_DIR}/debug/lib"
    )
    set("${prefix}_OPTIONS_RELEASE" "${options_release}" PARENT_SCOPE)
    set("${prefix}_OPTIONS_DEBUG" "${options_debug}" PARENT_SCOPE)
    set("${prefix}_LIBTOOLIZE" "${CURRENT_INSTALLED_DIR}/manual-tools/libltdl/libtoolize-ltdl-no-la" PARENT_SCOPE)
endfunction()
