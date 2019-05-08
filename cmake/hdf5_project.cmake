if(SEARCH_FOR_HDF5)
  message(STATUS "Searching for a suitable HDF5 library ...")
  if(NOT BUILD_SHARED_LIBS)
    set(HDF5_USE_STATIC_LIBRARIES True)
  endif()
  set(HDF5_PREFER_PARALLEL True)
  find_package(HDF5 "1.8.8" COMPONENTS C HL)
  if(HDF5_FOUND)
    if(NOT HDF5_IS_PARALLEL)
      set(HDF5_FOUND False)
      message(STATUS "Require parallel HDF5 library but found unsuitable serial library")
    endif()
  endif()
  if(HDF5_FOUND)
    add_library(hdf5 INTERFACE) # dummy target for dependencies
  endif()
endif()

if(HDF5_FOUND)
  list(APPEND projects_found "HDF5")
else()
  list(APPEND projects_to_build "HDF5")
  if(BUILD_SHARED_LIBS)
    set(hdf5_shlib_flag "--enable-shared" "--disable-static")
  else()
    set(hdf5_shlib_flag "--enable-static" "--disable-shared")
  endif()
  set(HDF5_VERSION "1.10.1")
  ExternalProject_Add(hdf5
    PREFIX hdf5
    URL ${TARFILE_DIR}/hdf5-${HDF5_VERSION}.tar.gz
    URL_MD5 628958679ccd5d9c0939912de082e7fa
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      CC=${MPI_C_COMPILER}
                      CFLAGS=${cflags}
                      --enable-option-checking
                      --enable-build-mode=production
                      --enable-parallel
                      --with-pic
                      --enable-hl
                      ${hdf5_shlib_flag}
                      --prefix=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND "$(MAKE)"
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  # These FindHDF5 variables are needed to configure dependent packages
  set(HDF5_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)
  set(HDF5_LIBRARY_DIRS ${CMAKE_INSTALL_PREFIX}/lib)
  if(BUILD_SHARED_LIBS)
    set(HDF5_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/libhdf5${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(HDF5_HL_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/libhdf5_hl${CMAKE_SHARED_LIBRARY_SUFFIX})
  else()
    set(HDF5_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/libhdf5${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(HDF5_HL_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/libhdf5_hl${CMAKE_STATIC_LIBRARY_SUFFIX})
  endif()
endif()
