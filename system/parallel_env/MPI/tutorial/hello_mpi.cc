#include <mpi.h> 
#include <stdio.h>

int main(int argc, char** argv) {
 
    MPI_Init(&argc, &argv);  // Init MPI

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);  // Get the number of process that could be used

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);  // Get the rank of the current process

    char processor_name[MPI_MAX_PROCESSOR_NAME]; 
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);  // Get the current process name

    printf("Hello world from processor %s, rank %d out of %d processors\n",
           processor_name, world_rank, world_size);
    MPI_Finalize();  // Free MPI
 
    return 0;
}