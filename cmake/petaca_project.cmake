if(SEARCH_FOR_PETACA)
  message(STATUS "Searching for a suitable Petaca library ...")
  find_package(PETACA)
endif()

if(PETACA_FOUND)
  list(APPEND projects_found "Petaca")
else()
  list(APPEND projects_to_build "Petaca")
  externalproject_add(petaca
    DEPENDS yajl
    PREFIX petaca
    URL ${TARFILE_DIR}/petaca-487aea2.tar.gz
    URL_MD5 6c492fb5d863a011935d06fea3593bcf
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_Fortran_COMPILER:PATH=${CMAKE_Fortran_COMPILER}
               -D CMAKE_Fortran_FLAGS:STRING=${CMAKE_Fortran_FLAGS}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D YAJL_INCLUDE_DIR:PATH=${YAJL_INCLUDE_DIR}
               -D YAJL_LIBRARY:PATH=${YAJL_LIBRARY}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
