if(SEARCH_FOR_HDF5)
  message(STATUS "Searching for a suitable HDF5 library ...")
  if(NOT BUILD_SHARED_LIBS)
    set(HDF5_USE_STATIC_LIBRARIES True)
  endif()
  set(HDF5_PREFER_PARALLEL True)
  find_package(HDF5 "1.14.3" COMPONENTS C HL)
  if(HDF5_FOUND)
    if(NOT HDF5_IS_PARALLEL)
      set(HDF5_FOUND False)
      message(STATUS "Require parallel HDF5 library but found unsuitable serial library")
    endif()
  endif()
  if(HDF5_FOUND)
    list(GET HDF5_INCLUDE_DIRS 0 HDF5_ROOT)
    get_filename_component(HDF5_ROOT ${HDF5_ROOT} DIRECTORY)
    add_library(hdf5 INTERFACE) # dummy target for dependencies
  endif()
endif()

if(HDF5_FOUND)
  list(APPEND projects_found "HDF5")
else()
  list(APPEND projects_to_build "HDF5")
  set(HDF5_VERSION "1.14.3")
  set(TRUCHAS_HDF5_PREFIX "truchas-")
  ExternalProject_Add(hdf5
    PREFIX hdf5
    URL ${TARFILE_DIR}/hdf5-${HDF5_VERSION}.tar.gz
    URL_MD5 075d923171c7785b2ee7d820b0ef8707
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
               -D HDF5_ENABLE_PARALLEL:BOOL=ON
               -D ONLY_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
               -D HDF5_BUILD_CPP_LIB:BOOL=OFF
               -D HDF5_EXTERNAL_LIB_PREFIX:STRING=${TRUCHAS_HDF5_PREFIX}
               -D BUILD_TESTING:BOOL=OFF
               -D HDF5_ENABLE_Z_LIB_SUPPORT=ON
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  # These FindHDF5 variables are needed to configure dependent packages
  set(HDF5_ROOT "${CMAKE_INSTALL_PREFIX}")
  set(HDF5_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)
  set(HDF5_LIBRARY_DIRS ${CMAKE_INSTALL_PREFIX}/lib)
  if(BUILD_SHARED_LIBS)
    set(HDF5_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/lib${TRUCHAS_HDF5_PREFIX}hdf5${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(HDF5_HL_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/lib${TRUCHAS_HDF5_PREFIX}hdf5_hl${CMAKE_SHARED_LIBRARY_SUFFIX})
  else()
    set(HDF5_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/lib${TRUCHAS_HDF5_PREFIX}hdf5${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(HDF5_HL_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/lib${TRUCHAS_HDF5_PREFIX}hdf5_hl${CMAKE_STATIC_LIBRARY_SUFFIX})
  endif()
endif()
