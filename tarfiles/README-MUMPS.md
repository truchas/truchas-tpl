Get the upstream source of the MUMPS code here:

    https://mumps-solver.org/MUMPS_5.7.3.tar.gz

Its build system is archaic, but this project

    https://github.com/scivision/mumps

provides a CMake build system. However it needs to be tweaked to work with
the NAG compiler. Those changes have been made to a fork of the project
located at

    https://github.com/nncarlson/mumps

The mumps-5.7.3.1-*.tar.gz tarball is an archive of the HEAD of its
nag-compiler branch. This modified version also grabs the MUMPS source from
the location specified by the url cmake command line variable rather than
from the URL above, so that it can work off-line as needed here. It also
applies a patch to that source internally. That patch is part of the
modified project, and makes changes needed to compile with the NAG compiler.

NNC, December 2024
