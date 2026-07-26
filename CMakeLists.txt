cmake_minimum_required(VERSION 3.20)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR
    "In-source builds are not supported. Run CMake from the repository root "
    "with a preset, for example:\n"
    "  cmake --preset linux-gcc\n"
    "or use an explicit build directory:\n"
    "  cmake -S . -B build/linux-gcc")
endif()

include(ExternalProject)
include(TruchasTPLExternalProject)
include(TruchasTPLPrefixMetadata)

project(TruchasTPL C CXX Fortran)

# Fix a few things that cmake gets wrong for the NAG compiler.
if(CMAKE_Fortran_COMPILER_ID MATCHES "NAG")
  set(CMAKE_Fortran_COMPILE_OPTIONS_PIE "-PIC")
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install"
      CACHE PATH "TPL install prefix" FORCE)
  list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")
endif()

set(TRUCHAS_TPL_EXTERNAL_CONFIGURE_STAMP
    "${PROJECT_BINARY_DIR}/CMakeFiles/truchas_tpl_external_configure_inputs.stamp")
add_custom_command(
  OUTPUT "${TRUCHAS_TPL_EXTERNAL_CONFIGURE_STAMP}"
  COMMAND "${CMAKE_COMMAND}" -E touch "${TRUCHAS_TPL_EXTERNAL_CONFIGURE_STAMP}"
  DEPENDS "${PROJECT_BINARY_DIR}/CMakeCache.txt"
  VERBATIM
)
add_custom_target(truchas_tpl_external_configure_inputs
  DEPENDS "${TRUCHAS_TPL_EXTERNAL_CONFIGURE_STAMP}")

option(BUILD_SHARED_LIBS "Build shared TPL libraries where supported" ON)
option(BUILD_PORTAGE "Build optional Portage and Wonton libraries" OFF)
option(BUILD_MUMPS "Build optional MUMPS and ScaLAPACK libraries" ON)

option(TRUCHAS_TPL_BUILD_SHARED "Build shared TPL libraries where supported" ${BUILD_SHARED_LIBS})
option(TRUCHAS_TPL_BUILD_PORTAGE "Build optional Portage and Wonton libraries" ${BUILD_PORTAGE})
option(TRUCHAS_TPL_BUILD_MUMPS "Build optional MUMPS and ScaLAPACK libraries" ${BUILD_MUMPS})

# Keep the original option names as internal compatibility variables for now.
set(BUILD_SHARED_LIBS "${TRUCHAS_TPL_BUILD_SHARED}" CACHE BOOL "Build shared TPL libraries where supported" FORCE)
set(BUILD_PORTAGE "${TRUCHAS_TPL_BUILD_PORTAGE}" CACHE BOOL "Build optional Portage and Wonton libraries" FORCE)
set(BUILD_MUMPS "${TRUCHAS_TPL_BUILD_MUMPS}" CACHE BOOL "Build optional MUMPS and ScaLAPACK libraries" FORCE)
set(MUMPS_LAPACK_VENDOR "" CACHE STRING
    "LAPACK vendor passed to the MUMPS CMake build")

# this will be passed to petaca to control naming conventions
option(ENABLE_STD_MOD_PROC_NAME "Build with -assume std_mod_proc_name when using Intel" OFF)

# This macro converts a cmake-style list of library paths (full) to a string
# of -L and and corresponding -l arguments suitable for a link line.
macro(lib_list_to_link_arg var)
  set(${var})
  foreach(lib ${ARGN})
    get_filename_component(libdir ${lib} DIRECTORY)
    list(APPEND ${var} "-L${libdir}")
    get_filename_component(lib ${lib} NAME_WE)
    string(REGEX REPLACE "^lib" "" lib ${lib})
    list(APPEND ${var} "-l${lib}")
  endforeach()
  string(REPLACE ";" " " ${var} "${${var}}")
  unset(lib)
  unset(libdir)
endmacro()

# This macro converts a cmake list of directory paths to a string of -I arguments.
macro(dir_list_to_includes var)
  string(REGEX REPLACE "([^;]+)" "-I\\1" ${var} "${ARGN}")
  string(REPLACE ";" " " ${var} "${${var}}")
endmacro()

# This macro converts a cmake list of library directory paths to a string of -L arguments.
macro(dir_list_to_link_dirs var)
  string(REGEX REPLACE "([^;]+)" "-L\\1" ${var} "${ARGN}")
  string(REPLACE ";" " " ${var} "${${var}}")
endmacro()

# MPI (needed by HYPRE, HDF5)
find_package(MPI REQUIRED)
include(TruchasTPLCompilers)

# Prefer the selected TPL library type only after MPI has been found. Applying
# this before FindMPI can force static MPI probes and break compiler detection.
if(BUILD_SHARED_LIBS)
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX}
                                  ${CMAKE_STATIC_LIBRARY_SUFFIX})
else()
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX}
                                  ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

# Gather the C and Fortran flags that would be used by cmake into a single
# variable.  These will be passed to external project configure scripts.
set(cflags "${CMAKE_C_FLAGS}")
set(fflags "${CMAKE_Fortran_FLAGS}")
set(cppflags "${CMAKE_CXX_FLAGS}")
if(CMAKE_BUILD_TYPE)
  string(TOUPPER "${CMAKE_BUILD_TYPE}" build_type)
  set(cflags "${cflags} ${CMAKE_C_FLAGS_${build_type}}")
  set(fflags "${fflags} ${CMAKE_Fortran_FLAGS_${build_type}}")
  set(cppflags "${cppflags} ${CMAKE_CXX_FLAGS_${build_type}}")
  string(STRIP "${cflags}" cflags)
  string(STRIP "${fflags}" fflags)
  string(STRIP "${cppflags}" cppflags)
endif()

# Most recent gcc compilers complain about HDF5 code
include(CheckCCompilerFlag)
check_c_compiler_flag("-std=c99" has_flag)
if(has_flag)
  set(cflags "${cflags} -std=c99")
endif()

#### Configure the TPLs as external projects as needed #########################

set(TARFILE_DIR ${PROJECT_SOURCE_DIR}/tarfiles)

set(projects_to_build)

include(hdf5_project)
include(fvtkhdf_project)
include(netcdf_project)
include(exodus_project)
include(hypre_project)
include(yajl_project)
include(petaca_project)
include(chaparral_project)
include(scorpio_project)
include(metis_project)
if(BUILD_PORTAGE)
  include(wonton_project)
  include(portage_project)
endif()
if(BUILD_MUMPS)
  include(scalapack_project)
  include(mumps_project)
endif()

# Print a summary of the configuration.
message(STATUS "")

truchas_tpl_generate_prefix_metadata()
string(REPLACE ";" " " project_list "${projects_to_build}")
if(projects_to_build)
  message(STATUS "Packages to build: ${project_list}")
  message(STATUS "")
  message(STATUS "Packages will be installed in ${CMAKE_INSTALL_PREFIX}")
else()
  message(STATUS "No packages selected to build.")
endif()
message(STATUS "")
