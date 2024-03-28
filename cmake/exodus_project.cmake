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
  # list(GET HDF5_C_LIBRARIES 0 hdf5_library)
  # list(GET HDF5_HL_LIBRARIES 0 hdf5hl_library)
  ExternalProject_Add(exodus
    DEPENDS hdf5 netcdf
    PREFIX exodus
    URL ${TARFILE_DIR}/seacas-2023-11-27.tar.gz
    URL_MD5 3149e40612b5e452ffc2ee78ee8a2384
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_CXX_COMPILER:PATH=${MPI_CXX_COMPILER}
               -D CMAKE_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D CMAKE_INSTALL_RPATH:PATH=${CMAKE_INSTALL_PREFIX}/lib
               -D Seacas_ENABLE_SEACASExodus:BOOL=ON
               -D Seacas_ENABLE_TESTS:BOOL=OFF
               -D SEACASExodus_ENABLE_STATIC:BOOL=OFF
               -D TPL_ENABLE_Netcdf:BOOL=ON
               -D HDF5_NO_SYSTEM_PATHS:BOOL=ON
               -D HDF5_ROOT:PATH=${HDF5_ROOT}
               -D HDF5_C_ROOT:PATH=${HDF5_ROOT}
               # -D HDF5_C_ROOT:PATH=${HDF5_ROOT}
               # -D HDF5_C_LIBRARY_hdf5:PATH=${HDF5_C_LIBRARIES}
               # -D HDF5_C_LIBRARY_hdf5_hl:PATH=${HDF5_HL_LIBRARIES}
               -D HDF5_LIBRARIES:PATH=${HDF5_C_LIBRARIES}
               -D HDF5_INCLUDE_DIRS:PATH=${HDF5_INCLUDE_DIRS}
               -D Seacas_SKIP_FORTRANCINTERFACE_VERIFY_TEST:BOOL=ON
               -D Seacas_ENABLE_Zoltan:BOOL=OFF
               -D Seacas_ENABLE_DOXYGEN:BOOL=OFF
               -D Netcdf_ALLOW_MODERN=ON
               -D NetCDF_NO_SYSTEM_PATHS:BOOL=ON
               -D NetCDF_ROOT:PATH=${netCDF_ROOT}
               -D TPL_ENABLE_MPI=ON
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
