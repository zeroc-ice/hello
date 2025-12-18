cmake_minimum_required(VERSION 3.21)

project(greeter CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Ice for C++ on Windows is shipped as a NuGet package.
if(WIN32)
  set(Ice_NUGET_NAME "ZeroC.Ice.Cpp")
  set(Ice_NUGET_DIR "${CMAKE_CURRENT_LIST_DIR}/packages/${Ice_NUGET_NAME}")

  if(NOT EXISTS ${Ice_NUGET_DIR})

    # Check if the nuget command line tool is available (either in the PATH or previously downloaded).
    # If not download it.
    find_program(NUGET_EXE nuget HINTS "${CMAKE_CURRENT_LIST_DIR}/packages" DOC "Path to nuget.exe")
    if(NOT NUGET_EXE)
      set(NUGET_URL "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" CACHE STRING "NuGet command line tool URL")
      message(STATUS "Downloading NuGet command line tool: ${NUGET_URL}")
      file(DOWNLOAD ${NUGET_URL} ${CMAKE_CURRENT_LIST_DIR}/packages/nuget.exe)
      set(NUGET_EXE "${CMAKE_CURRENT_LIST_DIR}/packages/nuget.exe" CACHE FILEPATH "Path to downloaded nuget.exe")
    endif()

    # Download the Ice NuGet package using the nuget command line tool.
    message(STATUS "Downloading Ice NuGet package: ${Ice_NUGET_NAME}")
    set(ICE_NUGET_SOURCE "https://api.nuget.org/v3/index.json" CACHE STRING "Ice NuGet package source")
    execute_process(
      COMMAND ${NUGET_EXE} install -Source ${ICE_NUGET_SOURCE} -OutputDirectory ${CMAKE_CURRENT_LIST_DIR}/packages ${Ice_NUGET_NAME} -Prerelease -ExcludeVersion
      RESULT_VARIABLE nuget_result
      OUTPUT_VARIABLE nuget_output
      ERROR_VARIABLE nuget_error)
    if(nuget_result)
      message(FATAL_ERROR "Failed to download Ice NuGet package: ${nuget_error}")
    endif()
  endif()

  # Set Ice_Root to the Ice NuGet package path. This is a special variable
  # that is used by CMake to find the Ice CMake config.
  set(Ice_ROOT "${Ice_NUGET_DIR}" CACHE PATH "Path to Ice installation directory")
endif()

find_package(Ice REQUIRED CONFIG)

add_executable(server src/Server.cpp src/Chatbot.cpp src/Chatbot.h src/slice/Greeter.ice)
slice2cpp_generate(server)
target_link_libraries(server PRIVATE Ice::Ice)
add_custom_command(TARGET server POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:server>
    $<TARGET_RUNTIME_DLLS:server>
    $<GENEX_EVAL:$<TARGET_PROPERTY:Ice::Ice,ICE_RUNTIME_DLLS>>
  COMMAND_EXPAND_LISTS
)
