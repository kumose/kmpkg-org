kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libtom/libtomcrypt
    REF v1.18.2
    SHA512 53accb4f92077ff1c52102bece270e77c497e599c392aa0bf4dbc173b6789e7e4f1012d8b5f257c438764197cb7bac8ba409a9d4e3a70e69bec5863b9495329e
    HEAD_REF develop
)

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

    if(KMPKG_CRT_LINKAGE STREQUAL "dynamic")
        set(CRTFLAG "/MD")
    else()
        set(CRTFLAG "/MT")
    endif()

    # Make sure we start from a clean slate
    kmpkg_execute_build_process(
        COMMAND nmake -f ${SOURCE_PATH}/makefile.msvc clean
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME clean-${TARGET_TRIPLET}-dbg
    )

    #Debug Build
    kmpkg_execute_build_process(
        COMMAND nmake -f ${SOURCE_PATH}/makefile.msvc "CFLAGS=${CRTFLAG}d /DUSE_LTM /DLTM_DESC \"/I${CURRENT_INSTALLED_DIR}/include\""
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME build-${TARGET_TRIPLET}-dbg
    )

    file(INSTALL
        ${SOURCE_PATH}/tomcrypt.lib
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
    )

    # Clean up necessary to rebuild without debug symbols
    kmpkg_execute_build_process(
        COMMAND nmake -f ${SOURCE_PATH}/makefile.msvc clean
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME clean-${TARGET_TRIPLET}-rel
    )

    #Release Build
    kmpkg_execute_build_process(
        COMMAND nmake -f ${SOURCE_PATH}/makefile.msvc "CFLAGS=${CRTFLAG} /Ox /DNDEBUG /DUSE_LTM /DLTM_DESC \"/I${CURRENT_INSTALLED_DIR}/include\""
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME build-${TARGET_TRIPLET}-rel
    )

    file(INSTALL
        ${SOURCE_PATH}/tomcrypt.lib
        DESTINATION ${CURRENT_PACKAGES_DIR}/lib
    )

    file(INSTALL
        ${SOURCE_PATH}/src/headers/
        DESTINATION ${CURRENT_PACKAGES_DIR}/include
    )
else()
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        set(MAKE_FILE "makefile.shared")
    else()
        set(MAKE_FILE "makefile")
    endif()

    set(ENV{CFLAGS} "-fPIC -DUSE_LTM -DLTM_DESC -I${CURRENT_INSTALLED_DIR}/include")

    kmpkg_execute_build_process(
        COMMAND make -f ${MAKE_FILE} clean
        WORKING_DIRECTORY ${SOURCE_PATH}
    )
    kmpkg_execute_build_process(
        COMMAND make -j${KMPKG_CONCURRENCY} -f ${MAKE_FILE} PREFIX=${CURRENT_PACKAGES_DIR}/debug LTC_DEBUG=1 install
        WORKING_DIRECTORY ${SOURCE_PATH}
    )
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

    kmpkg_execute_build_process(
        COMMAND make -f ${MAKE_FILE} clean
        WORKING_DIRECTORY ${SOURCE_PATH}
    )
    kmpkg_execute_build_process(
        COMMAND make -j${KMPKG_CONCURRENCY} -f ${MAKE_FILE} PREFIX=${CURRENT_PACKAGES_DIR} install
        WORKING_DIRECTORY ${SOURCE_PATH}
    )
    
endif()

#Copy license
file(
    INSTALL 
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright
)