if(SEARCH_FOR_PORTAGE)
  message(STATUS "Searching for a suitable wonton library ...")
  find_package(wonton)
endif()

if(wonton_FOUND)
  list(APPEND projects_found "wonton")
  add_custom_target(wonton)
else()
  list(APPEND projects_to_build "wonton")
  set(WONTON_VERSION "1.2.11")
  externalproject_add(wonton
    PREFIX wonton
    URL ${TARFILE_DIR}/wonton-${WONTON_VERSION}.tar.gz
    URL_MD5 81d1a2fa3069398b8c4fdee70881d3a7
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  set(wonton_ROOT "${CMAKE_INSTALL_PREFIX}")
endif()
