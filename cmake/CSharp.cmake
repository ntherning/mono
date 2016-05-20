include(ToNativePath)

if(NOT MCS_PATH)
  # Prefer the environment variable
  if(NOT $ENV{MCS_PATH} STREQUAL "")
    get_filename_component(MCS_PATH $ENV{MCS_PATH} PROGRAM PROGRAM_ARGS MCS_PATH_FLAGS)
    if(NOT EXISTS ${MCS_PATH})
      message(FATAL_ERROR "Could not find compiler set in environment variable MCS_PATH")
    endif()
  else()
    set(MCS_PATH_NAME mcs)
    set(CANDIDATE_PATHS $ENV{MONO_HOME}/bin)
    if(WIN32)
      set(MCS_PATH_NAME mcs.bat)
      set(CANDIDATE_PATHS ${CANDIDATE_PATHS} "C:/Program Files (x86)/Mono/bin")
    elseif(CYGWIN)
      set(MCS_PATH_NAME mcs.bat)
      set(CANDIDATE_PATHS ${CANDIDATE_PATHS} "/cygdrive/c/Program Files (x86)/Mono/bin")
    endif()
    find_program(MCS_PATH NAMES ${MCS_PATH_NAME} PATHS ${CANDIDATE_PATHS})
    if(NOT EXISTS ${MCS_PATH})
      message(FATAL_ERROR "Mono C# compiler could not be located")
    endif()
  endif()
  set(MCS_PATH "${MCS_PATH}" CACHE FILEPATH "Mono C# compiler path")
endif()

if(NOT MCS_PATH_WORKS)
  message(STATUS "Check for working Mono C# compiler: ${MCS_PATH}")
  file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/TestCSharpCompiler.cs "public class Foo { public static int Main (string[] args) { return 0; } }")
  to_native_path(${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/TestCSharpCompiler.cs TEST_CSHARP_COMPILER_CS)
  to_native_path(${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/TestCSharpCompiler.exe TEST_CSHARP_COMPILER_EXE)
  execute_process(COMMAND ${MCS_PATH} -out:${TEST_CSHARP_COMPILER_EXE} ${TEST_CSHARP_COMPILER_CS} RESULT_VARIABLE MCS_PATH_EXITCODE ERROR_VARIABLE ERROR_IGNORED)
  if(MCS_PATH_EXITCODE EQUAL 0)
    set(MCS_PATH_WORKS YES)
    execute_process(COMMAND ${MCS_PATH} --version OUTPUT_VARIABLE MCS_PATH_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX REPLACE "Mono C# compiler version ([0-9.]+)" "\\1" MCS_PATH_VERSION "${MCS_PATH_VERSION}")
  endif()
  if(NOT MCS_PATH_WORKS)
    message(STATUS "Check for working Mono C# compiler: ${MCS_PATH} -- broken")
    message(FATAL_ERROR "The Mono C# compiler \"${MCS_PATH}\" is not able to compile a simple test program.")
  elseif(MCS_PATH_VERSION VERSION_LESS "4.0")
    message(STATUS "Check for working Mono C# compiler: ${MCS_PATH} -- unsupported version")
    message(FATAL_ERROR "Unsupported Mono C# compiler version ${MCS_PATH_VERSION}. Expected >= 4.0.")
  else()
    message(STATUS "Check for working Mono C# compiler: ${MCS_PATH} -- works")
  endif()

  set(MCS_PATH_WORKS YES CACHE INTERNAL "")
endif()

function(_cs_add_assembly FUNC TARGET TYPE)
  set(CURR_LIST)
  set(FLAGS)
  set(SOURCES)
  set(DEPENDS)
  set(LIBRARIES)
  foreach(ARG ${ARGN})
    if(ARG STREQUAL "FLAGS")
      set(CURR_LIST "FLAGS")
    elseif(ARG STREQUAL "SOURCES")
      set(CURR_LIST "SOURCES")
    elseif(ARG STREQUAL "DEPENDS")
      set(CURR_LIST "DEPENDS")
    elseif(ARG STREQUAL "LIBRARIES")
      set(CURR_LIST "LIBRARIES")
    elseif(ARG STREQUAL "FOLDER")
      set(CURR_LIST "FOLDER")
    else()
      if(NOT CURR_LIST)
        message(FATAL_ERROR "Error in ${FUNC}(...) arguments")
      endif()
      list(APPEND "${CURR_LIST}" ${ARG})
      if(ARG STREQUAL "FOLDER")
        # Only a single item is allowed in this list
        unset(CURR_LIST)
      endif()
    endif()
  endforeach()

  set(TARGET_FILE "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${TARGET}.${TYPE}")
  to_native_path(${TARGET_FILE} TARGET_FILE_NATIVE)
  set(OPTS -out:${TARGET_FILE_NATIVE} ${FLAGS})
  if("${TYPE}" MATCHES "dll")
    set(OPTS ${OPTS} -target:library)
  endif()
  foreach(LIB ${LIBRARIES})
    if(TARGET ${LIB})
      get_target_property(LIB_FILE ${LIB} "TARGET_FILE")
      if(LIB_FILE)
        to_native_path(${LIB_FILE} LIB_FILE_NATIVE)
        set(OPTS ${OPTS} "-r:${LIB_FILE_NATIVE}")
        set(DEPENDS ${DEPENDS} ${LIB})
      else()
        set(OPTS ${OPTS} "-r:${LIB}")
      endif()
    else()
      set(OPTS ${OPTS} "-r:${LIB}")
    endif()
  endforeach()

  add_custom_command(OUTPUT ${TARGET_FILE}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}
    COMMAND ${MCS_PATH} ${OPTS} ${SOURCES}
    DEPENDS ${DEPENDS} ${SOURCES}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Compiling assembly ${TARGET}.${TYPE}"
    VERBATIM)
  add_custom_target(${TARGET} DEPENDS ${TARGET_FILE} SOURCES ${SOURCES})
  set_target_properties(${TARGET} PROPERTIES "TARGET_FILE" ${TARGET_FILE})
  if(FOLDER)
    set_target_properties(${TARGET} PROPERTIES FOLDER ${FOLDER})
  endif()
endfunction()

function(cs_add_executable TARGET)
  _cs_add_assembly("cs_add_executable" ${TARGET} exe ${ARGN})
endfunction()

function(cs_add_library TARGET)
  _cs_add_assembly("cs_add_library" ${TARGET} dll ${ARGN})
endfunction()
