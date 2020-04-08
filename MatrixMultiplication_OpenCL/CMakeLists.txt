cmake_minimum_required(VERSION 3.1)

project(CPP_OpenCL_MatMul)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)


set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -g")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall -Ofast -flto -mpopcnt -fwhole-program -march=native")

file(STRINGS "includelist.cmake" includes)

include_directories(${includes})
include(sourcelist.cmake)

find_package(OpenCL REQUIRED)

add_executable(CPP_OpenCL_MatMul ${sources})
target_link_libraries(CPP_OpenCL_MatMul OpenCL::OpenCL)