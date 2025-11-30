include(CMakeFindDependencyMacro)
find_dependency(asio CONFIG)
find_dependency(msgpack-cxx CONFIG)

get_filename_component(kmpkg_rest_rpc_prefix_path "${CMAKE_CURRENT_LIST_DIR}" PATH)
get_filename_component(kmpkg_rest_rpc_prefix_path "${kmpkg_rest_rpc_prefix_path}" PATH)

if(NOT TARGET unofficial::rest-rpc::rest-rpc)
    add_library(unofficial::rest-rpc::rest-rpc INTERFACE IMPORTED)
    target_include_directories(unofficial::rest-rpc::rest-rpc INTERFACE "${kmpkg_rest_rpc_prefix_path}/include")
    target_link_libraries(unofficial::rest-rpc::rest-rpc INTERFACE asio::asio msgpack-cxx)
endif()

unset(kmpkg_rest_rpc_prefix_path)
