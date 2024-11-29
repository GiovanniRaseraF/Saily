cmake_minimum_required(VERSION 3.14)
project(test_iot_sender)

# GoogleTest requires at least C++14
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()
include_directories(${CMAKE_SOURCE_DIR}/../src/)
include_directories(${CMAKE_SOURCE_DIR}/../src/buildsqlite)
link_directories(${CMAKE_SOURCE_DIR}/../src/buildsqlite)

add_executable(
  tests 
  main.cpp
)

target_link_libraries(
  tests
  GTest::gtest_main
  GTest::gmock_main
)

# boost
set(Boost_USE_STATIC_LIBS OFF) 
set(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF) 
find_package(Boost 1.70.0 COMPONENTS filesystem regex) 

if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS}) 
    target_link_libraries(tests ${Boost_LIBRARIES})
endif()

target_link_libraries (tests sqlite3)

include(GoogleTest)
gtest_discover_tests(tests)