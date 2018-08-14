cmake_minimum_required(VERSION 3.8)
project(helloqt CXX)

# Project options
option(HELLOQT_WARNINGS_AS_ERRORS "Warnings as errors" ON)
option(HELLOQT_USE_BUNDLED_QT "Use bundled version of Qt" OFF)

# Default to a Release build
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
    message(STATUS "Defaulting to a Release build")
endif()

# Set hard requirements for C++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Warn on CMake API deprecations
set(CMAKE_WARN_DEPRECATED ON)

# Disable in-source builds
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(SEND_ERROR "In-source builds are not allowed.")
endif()

# Add the module directory to the list of paths
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/CMakeModules")

# Compiler flags
if (MSVC)
    set(HELLOQT_CXX_FLAGS
        /std:c++latest # CMAKE_CXX_STANDARD as no effect on MSVC until CMake 3.10.
        /W4
        /w34263 # Non-virtual member function hides base class virtual function
        /w44265 # Class has virtual functions, but destructor is not virtual
        /w34456 # Declaration of 'var' hides previous local declaration
        /w34457 # Declaration of 'var' hides function parameter
        /w34458 # Declaration of 'var' hides class member
        /w34459 # Declaration of 'var' hides global definition
        /w34946 # Reinterpret-cast between related types
        /wd4592 # Symbol will be dynamically initialized (implementation limitation)
        /permissive- # Stricter C++ standards conformance
        /MP
        /Zi
        /Zo
        /EHsc
        /Zc:throwingNew # Assumes new never returns null
        /Zc:inline # Omits inline functions from object-file output
        /DNOMINMAX)

    if (HELLOQT_WARNINGS_AS_ERRORS)
        list(APPEND HELLOQT_CXX_FLAGS
             /WX)
    endif()

    if (CMAKE_VS_PLATFORM_TOOLSET MATCHES "LLVM-vs[0-9]+")
        list(APPEND HELLOQT_CXX_FLAGS
             -Qunused-arguments
             -Wno-missing-braces)
    endif()
else()
    set(HELLOQT_CXX_FLAGS
        -Wall
        -Wextra
        -Wcast-qual
        -pedantic
        -pedantic-errors
        -Wfatal-errors
        -Wno-missing-braces)

    if (HELLOQT_WARNINGS_AS_ERRORS)
        list(APPEND HELLOQT_CXX_FLAGS
             -Werror)
    endif()
endif()

# Qt
if (HELLOQT_USE_BUNDLED_QT)
    if (MSVC14)
        set(QT_VER qt-5.10.0-msvc2017_64)
    else()
        message(FATAL_ERROR "No bundled Qt binaries for your toolchain. Disable HELLOQT_USE_BUNDLED_QT and provide your own.")
    endif()

    if (DEFINED QT_VER)
        include(DownloadBundledExternal)
        download_bundled_external("qt/" ${QT_VER} QT_PREFIX)
    endif()

    set(QT_PREFIX_HINT HINTS "${QT_PREFIX}")
endif()
find_package(Qt5 REQUIRED COMPONENTS Widgets ${QT_PREFIX_HINT})

# Enable unit-testing
enable_testing(true)

# Project files
add_executable(helloqt main.cpp)
include(CreateDirectoryGroups)
create_directory_groups(helloqt)
target_link_libraries(helloqt Qt5::Widgets)
