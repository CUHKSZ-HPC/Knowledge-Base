PROGRAM hello_world_mpi
include "mpif.h"

integer rank, size, ierror

call MPI_INIT(ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)

print *, 'Hello World from process: ', rank, 'of ', size

call MPI_BARRIER(MPI_COMM_WORLD, ierror)
call MPI_FINALIZE(ierror)

END PROGRAM
