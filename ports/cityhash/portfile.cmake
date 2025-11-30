kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/cityhash
    REF 8af9b8c2b889d80c22d6bc26ba0df1afb79a30db
    SHA512 5878a6a4f8ee99593412d446d96c05be1f89fa7771eca49ff4a52ce181de8199ba558170930996d36f6df80a65889d93c81ab2611868b015d8db913e2ecd2eb9
    HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

if(KMPKG_TARGET_IS_WINDOWS)
	file(COPY "${CMAKE_CURRENT_LIST_DIR}/config.h" DESTINATION "${SOURCE_PATH}/src")
else()
	file(MAKE_DIRECTORY "${SOURCE_PATH}/out")
	kmpkg_execute_required_process(
		COMMAND "${SOURCE_PATH}/configure"
		WORKING_DIRECTORY "${SOURCE_PATH}/out"
		LOGNAME configure-${TARGET_TRIPLET}
	)
	file(COPY "${SOURCE_PATH}/out/config.h" DESTINATION "${SOURCE_PATH}/src")
endif()

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "sse"   ENABLE_SSE
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/cityhash)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include"
                    "${CURRENT_PACKAGES_DIR}/debug/share")

configure_file("${SOURCE_PATH}/COPYING" "${CURRENT_PACKAGES_DIR}/share/cityhash/copyright" COPYONLY)
