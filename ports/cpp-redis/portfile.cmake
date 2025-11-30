kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cpp-redis/cpp_redis
    REF 4.3.1
    SHA512 abf372542c53f37f504b3211b840b100d07a8f4b2e7f5584cc7550ab16ed617838e2df79064374c7a409458d8567f4834686318ea3a40249c767e36c744c7a47
    HEAD_REF master
    PATCHES 
        "fix-sleep_for.patch"
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/tacopie/CMakeLists.txt DESTINATION ${SOURCE_PATH}/tacopie)

if(KMPKG_CRT_LINKAGE STREQUAL "dynamic")
    set(MSVC_RUNTIME_LIBRARY_CONFIG "/MD")
else()
    set(MSVC_RUNTIME_LIBRARY_CONFIG "/MT")
endif()

if(KMPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" OR NOT KMPKG_CMAKE_SYSTEM_NAME)
    # cpp-redis forcibly removes "/RTC1" in its cmake file. Because this is an ABI-sensitive flag, we need to re-add it in a form that won't be detected.
    set(KMPKG_CXX_FLAGS_DEBUG "${KMPKG_CXX_FLAGS_DEBUG} -RTC1")
    set(KMPKG_C_FLAGS_DEBUG "${KMPKG_C_FLAGS_DEBUG} -RTC1")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DMSVC_RUNTIME_LIBRARY_CONFIG=${MSVC_RUNTIME_LIBRARY_CONFIG}
)

kmpkg_cmake_install()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(GLOB_RECURSE FILES "${CURRENT_PACKAGES_DIR}/include/*")
foreach(file ${FILES})
    file(READ ${file} _contents)
    string(REPLACE "ifndef __CPP_REDIS_USE_CUSTOM_TCP_CLIENT" "if 1" _contents "${_contents}")
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        string(REPLACE
            "extern std::unique_ptr<logger_iface> active_logger;"
            "extern __declspec(dllimport) std::unique_ptr<logger_iface> active_logger;"
            _contents "${_contents}")
    endif()
    file(WRITE ${file} "${_contents}")
endforeach()

file(GLOB FILES_TO_REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/cpp_redis.ilk" "${CURRENT_PACKAGES_DIR}/bin/cpp_redis.dll.manifest")
if(FILES_TO_REMOVE)
    file(REMOVE_RECURSE ${FILES_TO_REMOVE})
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

kmpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
kmpkg_fixup_pkgconfig()
