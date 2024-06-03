# Generic Linux with the Intel Compilers

set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
set(CMAKE_C_COMPILER $ENV{CC} CACHE STRING "C Compiler")
set(CMAKE_CXX_COMPILER $ENV{CXX} CACHE STRING "C++ Compiler")
set(CMAKE_Fortran_COMPILER $ENV{FC} CACHE STRING "Fortran Compiler")

set(CMAKE_C_FLAGS "-Wno-implicit-function-declaration -Wno-implicit-int -fp-model=precise" CACHE STRING "C compile flags")
