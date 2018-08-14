function(download_bundled_external remote_path lib_name prefix_var)
    set(prefix "${CMAKE_BINARY_DIR}/externals/${lib_name}")
    if (NOT EXISTS "${prefix}")
        message(STATUS "Downloading binaries for ${lib_name}...")
        file(DOWNLOAD
             https://github.com/citra-emu/ext-windows-bin/raw/master/${remote_path}${lib_name}.7z
             "${CMAKE_BINARY_DIR}/externals/${lib_name}.7z" SHOW_PROGRESS)
        execute_process(COMMAND ${CMAKE_COMMAND} -E tar xf "${CMAKE_BINARY_DIR}/externals/${lib_name}.7z"
                        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/externals")
    endif()
    message(STATUS "Using bundled binaries at ${prefix}")
    set(${prefix_var} "${prefix}" PARENT_SCOPE)
endfunction()
