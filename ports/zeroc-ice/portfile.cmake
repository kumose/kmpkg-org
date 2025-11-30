kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zeroc-ice/ice
    REF "v${VERSION}"
    SHA512 638ca8721db1559aae80c43663a1210ba9c8f72d58003f2d9457048c9100bee74036910917d1d10bf5b998ba49f0878177e094b436c83d3deb63613f9075483d
    PATCHES
        mcppd_fix.patch
        no-werror.patch
)

set(RELEASE_TRIPLET ${TARGET_TRIPLET}-rel)
set(DEBUG_TRIPLET ${TARGET_TRIPLET}-dbg)

set(UNIX_BUILD_DIR "${SOURCE_PATH}")
set(WIN_DEBUG_BUILD_DIR "${CURRENT_BUILDTREES_DIR}/${DEBUG_TRIPLET}")
set(WIN_RELEASE_BUILD_DIR "${CURRENT_BUILDTREES_DIR}/${RELEASE_TRIPLET}")

# install_includes
function(install_includes ORIGINAL_PATH RELATIVE_PATHS)
    foreach(RELATIVE_PATH ${RELATIVE_PATHS})
        file(GLOB HEADER_FILES ${ORIGINAL_PATH}/${RELATIVE_PATH}/*.h)
        if(EXISTS "${ORIGINAL_PATH}/${RELATIVE_PATH}")
            file(COPY ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/${RELATIVE_PATH}")
        endif()
    endforeach()
endfunction()

# install_slices
function(install_slices ORIGINAL_PATH RELATIVE_PATHS)
    foreach(RELATIVE_PATH ${RELATIVE_PATHS})
        file(GLOB HEADER_FILES ${ORIGINAL_PATH}/${RELATIVE_PATH}/*.ice)
        if(EXISTS ${ORIGINAL_PATH}/${RELATIVE_PATH})
            file(COPY ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/share/ice/slice/${RELATIVE_PATH}")
        endif()
    endforeach()
endfunction()

kmpkg_list(SET ICE_INCLUDE_SUB_DIRECTORIES
  "Glacier2"
  "Ice"
  "IceUtil"
  "IceBT"
  "IceBox"
  "IceBT"
  "IceDiscovery"
  "IceGrid"
  "IceIAP"
  "IceLocatorDiscovery"
  "IcePatch2"
  "IceSSL"
  "IceStorm"
)

set(ICE_OPTIONAL_COMPONENTS_MSBUILD "")
set(ICE_OPTIONAL_COMPONENTS_MAKE "Ice") # Intentional!
set(pkgconfig_packages "")

# IceSSL
if("icessl" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\icessl++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceSSL")
endif()

# Glacier2
if("glacier2lib" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\glacier2++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "Glacier2")
endif()

# Glacier2Router
if("glacier2router" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\glacier2router")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\glacier2cryptpermissionsverifier")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "glacier2router")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "Glacier2CryptPermissionsVerifier")
endif()

# IceBox
if("iceboxlib" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\iceboxlib++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceBox")
endif()

# IceBox
if("iceboxtools" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\icebox++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\iceboxadmin")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icebox")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "iceboxadmin")
endif()

# IceGrid
if("icegridlib" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\icegrid++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceGrid")
endif()

# IceGrid tools
if("icegridtools" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icegridadmin")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icegridregistry")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icegridnode")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icegridnode")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icegridregistry")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icegridnode")
    list(APPEND pkgconfig_packages expat)
endif()

# IceStorm
if("icestormlib" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\icestorm++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceStorm")
endif()

# IceStormAdmin
if("icestormtools" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icestormadmin")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icestormservice")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icestormdb")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icestormadmin")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceStormService")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icestormdb")
endif()

# IceBridge executable
if("icebridge" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++98\\icebridge")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "icebridge")
endif()

# IceDiscovery
if("icediscovery" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\icediscovery++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceDiscovery")
endif()

# IceLocatorDiscovery
if("icelocatordiscovery" IN_LIST FEATURES)
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MSBUILD "/t:C++11\\icelocatordiscovery++11")
    kmpkg_list(APPEND ICE_OPTIONAL_COMPONENTS_MAKE "IceLocatorDiscovery")
endif()

if(NOT KMPKG_TARGET_IS_WINDOWS)
    # Clean up for the first round (important for install --editable)
    kmpkg_execute_build_process(
        COMMAND make distclean
        WORKING_DIRECTORY ${SOURCE_PATH}/cpp
        LOGNAME make-clean-${TARGET_TRIPLET}
    )

    if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib")
        file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/lib")
    endif()
    if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib64")
        file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/lib64")
    endif()
    file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/bin")

    # Setting these as environment variables, as .d files aren't generated
    # the first time passing them as arguments to make.
    set(ENV{MCPP_HOME} ${CURRENT_INSTALLED_DIR})
    set(ENV{EXPAT_HOME} ${CURRENT_INSTALLED_DIR})
    set(ENV{BZ2_HOME} ${CURRENT_INSTALLED_DIR})
    set(ENV{LMDB_HOME} ${CURRENT_INSTALLED_DIR})
    set(ENV{CPPFLAGS} "-I${CURRENT_INSTALLED_DIR}/include")
    set(ENV{LDFLAGS} "-L${CURRENT_INSTALLED_DIR}/debug/lib")

    set(ICE_BUILD_CONFIG "shared cpp11-shared")
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        set(ICE_BUILD_CONFIG "static cpp11-static")
    endif()
    if(NOT KMPKG_BUILD_TYPE)
    message(STATUS "Building ${TARGET_TRIPLET}-dbg")
        kmpkg_execute_build_process(
            COMMAND make
                V=1
                "prefix=${CURRENT_PACKAGES_DIR}/debug"
                linux_id=kmpkg
                "CONFIGS=${ICE_BUILD_CONFIG}"
                USR_DIR_INSTALL=yes
                OPTIMIZE=no
                ${ICE_OPTIONAL_COMPONENTS_MAKE}
                "-j${KMPKG_CONCURRENCY}"
            WORKING_DIRECTORY ${SOURCE_PATH}/cpp
            LOGNAME make-${TARGET_TRIPLET}-dbg
        )

        # Install debug libraries to packages directory
        file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/lib")
        if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib64")
            file(GLOB ICE_DEBUG_LIBRARIES "${UNIX_BUILD_DIR}/cpp/lib64/*")
        else()
            file(GLOB ICE_DEBUG_LIBRARIES "${UNIX_BUILD_DIR}/cpp/lib/*")
        endif()
        file(COPY ${ICE_DEBUG_LIBRARIES} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")

        # Clean up for the next round
        kmpkg_execute_build_process(
            COMMAND make distclean
            WORKING_DIRECTORY ${SOURCE_PATH}/cpp
            LOGNAME make-clean-${TARGET_TRIPLET}
        )

        if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib")
            file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/lib")
        endif()
        if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib64")
            file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/lib64")
        endif()
        file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/bin")
    endif() # TODO: get-cmake-vars!
    # Release build
    set(ENV{LDFLAGS} "-L${CURRENT_INSTALLED_DIR}/lib")
    message(STATUS "Building ${TARGET_TRIPLET}-rel")
    kmpkg_execute_build_process(
        COMMAND make
            V=1
            "prefix=${CURRENT_PACKAGES_DIR}"
            linux_id=kmpkg
            "CONFIGS=${ICE_BUILD_CONFIG}"
            USR_DIR_INSTALL=yes
            OPTIMIZE=yes
            ${ICE_OPTIONAL_COMPONENTS_MAKE}
            "-j${KMPKG_CONCURRENCY}"
        WORKING_DIRECTORY ${SOURCE_PATH}/cpp
        LOGNAME make-${TARGET_TRIPLET}-rel
    )

    # Install release libraries and other files to packages directory
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/lib")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/include")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/ice/slice")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")

    install_includes("${UNIX_BUILD_DIR}/cpp/include" "${ICE_INCLUDE_SUB_DIRECTORIES}")
    install_includes("${UNIX_BUILD_DIR}/cpp/include/generated" "${ICE_INCLUDE_SUB_DIRECTORIES}")
    install_slices("${SOURCE_PATH}/slice" "${ICE_INCLUDE_SUB_DIRECTORIES}")
    if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib64")
        file(GLOB ICE_RELEASE_LIBRARIES "${UNIX_BUILD_DIR}/cpp/lib64/*")
    else()
        file(GLOB ICE_RELEASE_LIBRARIES "${UNIX_BUILD_DIR}/cpp/lib/*")
    endif()
    file(COPY ${ICE_RELEASE_LIBRARIES} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(GLOB ICE_RELEASE_EXECUTABLES "${UNIX_BUILD_DIR}/cpp/bin/*")
    file(COPY ${ICE_RELEASE_EXECUTABLES} DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")

    # Clean up
    kmpkg_execute_build_process(
        COMMAND make distclean
        WORKING_DIRECTORY ${SOURCE_PATH}/cpp
        LOGNAME make-clean-after-build-${TARGET_TRIPLET}
    )

    if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib")
        file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/lib")
    endif()
    if(EXISTS "${UNIX_BUILD_DIR}/cpp/lib64")
        file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/lib64")
    endif()
    file(REMOVE_RECURSE "${UNIX_BUILD_DIR}/cpp/bin")

else() # KMPKG_TARGET_IS_WINDOWS

    # Fix project files to prevent nuget restore of dependencies and
    # remove hard coded runtime linkage
    include("${CURRENT_PORT_DIR}/prepare_for_build.cmake")
    prepare_for_build("${SOURCE_PATH}")

    kmpkg_list(SET MSBUILD_OPTIONS
        "/p:UseKmpkg=yes"
        "/p:IceBuildingSrc=yes"
        ${ICE_OPTIONAL_COMPONENTS_MSBUILD}
    )

    # Build Ice
    kmpkg_msbuild_install(
        SOURCE_PATH "${SOURCE_PATH}"
        PROJECT_SUBPATH "cpp/msbuild/ice.${KMPKG_PLATFORM_TOOLSET}.sln"
        TARGET "C++11\\ice++11"
        OPTIONS
            ${MSBUILD_OPTIONS}
        DEPENDENT_PKGCONFIG bzip2 ${pkgconfig_packages}
        ADDITIONAL_LIBS lmdb.lib
        ADDITIONAL_LIBS_RELEASE mcpp.lib ${libs_rel}
        ADDITIONAL_LIBS_DEBUG mcppd.lib ${libs_dbg}
    )

    if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/zeroc.icebuilder.msbuild.dll")
        file(REMOVE "${CURRENT_PACKAGES_DIR}/bin/zeroc.icebuilder.msbuild.dll")
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/bin/zeroc.icebuilder.msbuild.dll")
        file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/zeroc.icebuilder.msbuild.dll")
    endif()

    install_includes("${WIN_RELEASE_BUILD_DIR}/cpp/include" "${ICE_INCLUDE_SUB_DIRECTORIES}")
    install_includes("${WIN_RELEASE_BUILD_DIR}/cpp/include/generated/cpp11/${TRIPLET_SYSTEM_ARCH}/Release" "${ICE_INCLUDE_SUB_DIRECTORIES}")

    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/ice/slice")
    install_slices("${SOURCE_PATH}/slice" "${ICE_INCLUDE_SUB_DIRECTORIES}")

    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
    endif()

    kmpkg_clean_msbuild()

endif()

# Remove unnecessary static libraries.
file(GLOB PDLIBS "${CURRENT_PACKAGES_DIR}/debug/lib/*")
file(GLOB PRLIBS "${CURRENT_PACKAGES_DIR}/lib/*")
list(FILTER PDLIBS INCLUDE REGEX ".*(([Ii]ce[Uu]til|[Ss]lice)d?\.([a-z]+))$")
list(FILTER PRLIBS INCLUDE REGEX ".*(([Ii]ce[Uu]til|[Ss]lice)d?\.([a-z]+))$")
file(REMOVE ${PDLIBS} ${PRLIBS})

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
