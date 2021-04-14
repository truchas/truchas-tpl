if(SEARCH_FOR_PORTAGE)
  message(STATUS "Searching for a suitable portage library ...")
  find_package(portage)
endif()

if(PORTAGE_FOUND)
  list(APPEND projects_found "portage")
  add_custom_target(portage)
else()
  list(APPEND projects_to_build "portage")
  set(PORTAGE_VERSION "3.0.0")
  externalproject_add(portage
    DEPENDS wonton
    PREFIX portage
    URL ${TARFILE_DIR}/portage-${PORTAGE_VERSION}.tar.gz
    URL_MD5 7ced58e86b008824b4fc9b0ac7549631
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D wonton_ROOT:PATH=${wonton_ROOT}
               -D BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  set(portage_ROOT ${CMAKE_INSTALL_PREFIX})
endif()
