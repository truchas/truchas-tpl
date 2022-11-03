if(SEARCH_FOR_EXODUS)
  message(STATUS "Searching for a suitable Exodus library ...")
  find_package(Exodus "8.11")
endif()

if(EXODUS_FOUND)
  list(APPEND projects_found "Exodus")
else()
  list(APPEND projects_to_build "Exodus")
  set(EXODUS_VERSION "8.11")
  # Go ahead and specify the library paths below so that the find_library calls
  # in the exodus CMakeLists.txt will be short-circuited.  I do not think the
  # libraries actually matter (for shared at least) because we are not building
  # any executables.  Note that an ldd on the built library may not show the
  # correct netcdf and hdf5 libraries, because the ones passed are not baked
  # into it, and whatever is found in LD_LIBRARY_PATH, if any, will be shown.
  # But when the truchas executable is linked, the proper libraries will be
  # used.  The libraries we want are the initial ones in the lists.
  list(GET HDF5_C_LIBRARIES 0 hdf5_library)
  list(GET HDF5_HL_LIBRARIES 0 hdf5hl_library)
  ExternalProject_Add(exodus
    DEPENDS hdf5 netcdf
    PREFIX exodus
    URL ${TARFILE_DIR}/seacas-2022-10-14.tar.gz
    URL_MD5 d2682321171323024100415c2faa5d88
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D CMAKE_INSTALL_RPATH:PATH=${CMAKE_INSTALL_PREFIX}/lib
               -D Seacas_ENABLE_SEACASExodus:BOOL=ON
               -D Seacas_ENABLE_TESTS:BOOL=OFF
               -D TPL_ENABLE_Netcdf:BOOL=ON
               -D HDF5_NO_SYSTEM_PATHS:BOOL=ON
               -D HDF5_ROOT:PATH=${HDF5_ROOT}
               -D Seacas_SKIP_FORTRANCINTERFACE_VERIFY_TEST:BOOL=ON
               -D Seacas_ENABLE_CXX11:BOOL=OFF
               -D Seacas_ENABLE_Zoltan:BOOL=OFF
               -D NetCDF_ROOT:PATH=${NETCDF_ROOT}
               -D TPL_ENABLE_MPI=ON
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
