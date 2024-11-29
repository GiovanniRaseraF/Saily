cmake_minimum_required(VERSION 3.16.3)

project(iot_sender)

include_directories(${CMAKE_SOURCE_DIR}/../src/)
include_directories(${CMAKE_SOURCE_DIR}/../src/buildsqlite)
link_directories(${CMAKE_SOURCE_DIR}/../src/buildsqlite)

add_executable(main main.cpp)
target_link_libraries (main sqlite3)
# boost
set(Boost_USE_STATIC_LIBS OFF) 
set(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF) 
find_package(Boost 1.70.0 COMPONENTS  filesystem regex) 

if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS}) 
    target_link_libraries(main ${Boost_LIBRARIES})
endif()

set_property(TARGET main PROPERTY CXX_STANDARD 23 CXX_O)
set(CMAKE_CXX_FLAGS "-Wall -Wextra")
