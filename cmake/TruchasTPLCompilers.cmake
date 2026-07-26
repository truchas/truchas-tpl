function(_truchas_tpl_compiler_family out_var compiler_id compiler_path)
  if(compiler_id MATCHES "^(GNU|Clang|AppleClang|IntelLLVM|NAG)$")
    set(family "${CMAKE_MATCH_1}")
  else()
    get_filename_component(compiler_name "${compiler_path}" NAME)
    if(compiler_name MATCHES "^(gcc|g\\+\\+|gfortran)(-[0-9.]+)?$")
      set(family "GNU")
    elseif(compiler_name MATCHES "^(clang|clang\\+\\+|flang)(-[0-9.]+)?$")
      set(family "Clang")
    elseif(compiler_name MATCHES "^(icx|icpx|ifx|ifort)$")
      set(family "IntelLLVM")
    elseif(compiler_name MATCHES "^nagfor")
      set(family "NAG")
    else()
      set(family "${compiler_id}")
    endif()
  endif()
  set("${out_var}" "${family}" PARENT_SCOPE)
endfunction()

function(_truchas_tpl_mpi_wrapper_family out_var show_var wrapper)
  set(show_output "")
  set(family "")

  if(wrapper AND EXISTS "${wrapper}")
    execute_process(
      COMMAND "${wrapper}" -show
      OUTPUT_VARIABLE show_output
      ERROR_VARIABLE show_error
      RESULT_VARIABLE show_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE
    )
    if(NOT show_result EQUAL 0)
      execute_process(
        COMMAND "${wrapper}" --show
        OUTPUT_VARIABLE show_output
        ERROR_VARIABLE show_error
        RESULT_VARIABLE show_result
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
      )
    endif()
    if(NOT show_result EQUAL 0)
      set(show_output "${show_error}")
    endif()
  endif()

  if(show_output)
    string(REGEX MATCH "^[^ ]+" backing_compiler "${show_output}")
    _truchas_tpl_compiler_family(family "" "${backing_compiler}")
  endif()

  set("${out_var}" "${family}" PARENT_SCOPE)
  set("${show_var}" "${show_output}" PARENT_SCOPE)
endfunction()

function(_truchas_tpl_validate_mpi_language lang cmake_lang compiler_id)
  if(NOT MPI_${lang}_FOUND)
    message(FATAL_ERROR "MPI ${cmake_lang} component was not found")
  endif()

  set(configured_compiler "${CMAKE_${cmake_lang}_COMPILER}")
  set(mpi_compiler "${MPI_${lang}_COMPILER}")

  _truchas_tpl_compiler_family(configured_family
    "${compiler_id}" "${configured_compiler}")
  _truchas_tpl_mpi_wrapper_family(mpi_family mpi_show "${mpi_compiler}")

  if(mpi_family
      AND configured_family
      AND NOT mpi_family STREQUAL configured_family
      AND NOT TRUCHAS_TPL_ALLOW_MPI_COMPILER_MISMATCH)
    message(FATAL_ERROR
      "MPI ${cmake_lang} wrapper appears to use ${mpi_family}, but "
      "CMake selected ${configured_family} for ${cmake_lang}. "
      "Set TRUCHAS_TPL_ALLOW_MPI_COMPILER_MISMATCH=ON to override.")
  endif()

  set(TRUCHAS_TPL_${cmake_lang}_COMPILER "${configured_compiler}" PARENT_SCOPE)
  set(TRUCHAS_TPL_MPI_${cmake_lang}_COMPILER "${mpi_compiler}" PARENT_SCOPE)
  set(TRUCHAS_TPL_MPI_${cmake_lang}_SHOW "${mpi_show}" PARENT_SCOPE)
endfunction()

option(TRUCHAS_TPL_ALLOW_MPI_COMPILER_MISMATCH
  "Allow MPI wrappers whose backing compiler family differs from CMake compilers"
  OFF)

_truchas_tpl_validate_mpi_language(C C "${CMAKE_C_COMPILER_ID}")
_truchas_tpl_validate_mpi_language(CXX CXX "${CMAKE_CXX_COMPILER_ID}")
_truchas_tpl_validate_mpi_language(Fortran Fortran "${CMAKE_Fortran_COMPILER_ID}")

message(STATUS "")
message(STATUS "Compiler/MPI selection:")
message(STATUS "  C:       ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION} (${CMAKE_C_COMPILER})")
message(STATUS "  CXX:     ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION} (${CMAKE_CXX_COMPILER})")
message(STATUS "  Fortran: ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION} (${CMAKE_Fortran_COMPILER})")
message(STATUS "  MPI C:       ${MPI_C_COMPILER}")
message(STATUS "  MPI CXX:     ${MPI_CXX_COMPILER}")
message(STATUS "  MPI Fortran: ${MPI_Fortran_COMPILER}")
message(STATUS "")
