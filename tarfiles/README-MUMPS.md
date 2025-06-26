Get the upstream source of the MUMPS code here:

    https://mumps-solver.org/MUMPS_5.7.3.tar.gz

Its build system is archaic, but this project

    https://github.com/scivision/mumps

provides a CMake build system. However it needs to be tweaked to work with
the NAG compiler. Those changes have been made to a fork of the project
located at

    https://gitlab.com/truchas/tpl-forks/mumps

The mumps-5.7.3.1-*.tar.gz tarball is an archive of the HEAD of its
truchas branch. This modified version also grabs the MUMPS source from
the location specified by the url cmake command line variable rather than
from the URL above, so that it can work off-line as needed here. It also
applies a patch to that source internally. That patch is part of the
modified project, and makes changes needed to compile with the NAG compiler.

NNC, December 2024

### The MUMPS Patch

The patch file `mumps-nag.patch` is contained in the `mumps-5.7.3.1-*.tar.gz`
tarball. It makes the following changes that are needed to compile MUMPS with
the NAG Fortran compiler:

* The header files `?mumps_struct.h` have been rewritten to use the `kind`
  parameters from `iso_fortran_env` rather than hardwired byte values.

* Includes of the header files within MUMPS are preceded by use of
  `iso_fortran_env` to make those parameters accessible. NOTE: application
  code must do the same thing when including the header files.

* Use of the intrinsic OMP_LIB module are protected by the "!$" (fixed form)
  openmp sentinel in statements where it was missing.

#### Background

The changes address the invalid assumption that the value of the `kind` type
parameter equals the desired byte size; e.g., `real(8)` specifies an 8-byte
real. While this happens to be true for most compilers, it is false for the
NAG compiler by default, and possibly other compilers. This is partly resolved
(for the NAG compiler) by using the `-kind=byte` option when compiling MUMPS.

However the problem persists in the `?mumps_struct.h` header files, which
application code must include. One solution is to build the application code
with `-kind=byte` also, but this forces all Fortran modules used by the code
to be compiled with the same option, as modules compiled with a different
`kind` numbering scheme are incompatible. The viral nature of this solution
makes it unacceptable. A better alternative implemented by the patch file is
to rewrite the header files to use the `kind` parameters from `iso_fortran_env`.

At one point during troubleshooting, a compatibility error with the intrinsic
`omp_lib` module was reported due to to it having been compiled with a different
`kind` numbering scheme, this despite the fact that the openmp option was
disabled when compiling MUMPS. The inadvertent use of `omp_lib` was due to a
missing "!$" sentinel on some use statements. The patch file fixes that too.

NOTE: NAG does supply a different version of the `omp_lib` module for each of
the `kind` numbering schemes it supports, so it is not clear why there was an
incompatiblilty error. This was not pursued as we presently have no interest
in exploiting the openmp capability of MUMPS.
