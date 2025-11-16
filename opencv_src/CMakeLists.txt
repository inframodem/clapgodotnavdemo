cmake_minimum_required(VERSION 3.10.0)
project(opencvclap)

# Read .env file and convert each KEY=VALUE into CMake variables
function(load_env_file ENV_FILE)
    if(EXISTS "${ENV_FILE}")
        file(READ "${ENV_FILE}" ENV_CONTENT)
        string(REPLACE "\n" ";" ENV_LINES "${ENV_CONTENT}")

        foreach(line IN LISTS ENV_LINES)
            if(line MATCHES "^[A-Za-z_][A-Za-z0-9_]*=.*$")
                string(REGEX MATCH "^[A-Za-z_][A-Za-z0-9_]*" KEY "${line}")
                string(REGEX REPLACE "^[A-Za-z_][A-Za-z0-9_]*=" "" VALUE "${line}")
                set(${KEY} "${VALUE}" PARENT_SCOPE)
            endif()
        endforeach()
    else()
        message(WARNING ".env file not found: ${ENV_FILE}")
    endif()
endfunction()
load_env_file("${CMAKE_SOURCE_DIR}/.env")
message(STATUS "OpenCV_DIR = ${OpenCV_INCLUDE_DIRS}")
find_package( OpenCV REQUIRED)

file(GLOB SRC_FILES
    "*.cpp"
)


add_executable(opencvclap ${SRC_FILES})
target_link_libraries(opencvclap ${OpenCV_LIBS})
