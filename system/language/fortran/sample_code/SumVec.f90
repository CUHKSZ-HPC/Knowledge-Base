program sumvector_mpi
      
c     This program sums all rows in a vector using MPI parallelism.
c     The root process acts as a master and sends a portion of the
c     vector to each child process.  Master and child processes then
c     all calculate a partial sum of the portion of the vector assigned
c     to them, and the child processes send their partial sums to 
c     the master, who calculates a grand total.
      
      include '/usr/include/mpif.h'
      parameter (max_rows = 10000000)
      parameter ( send_data_tag = 2001, return_data_tag = 2002)

      integer my_id, root_process, ierr, status(MPI_STATUS_SIZE)
      integer num_procs, an_id, num_rows_to_receive 
      integer avg_rows_per_process, num_rows, num_rows_to_send

      real vector(max_rows), vector2(max_rows), partial_sum, sum

c     Let process 0 be the root process.

      root_process = 0

c     Now replicate this process to create parallel processes.  
c     From this point on, every process executes a separate copy 
c     of this program.

      call MPI_INIT (ierr)

c     find out MY process ID, and how many processes were started.

      call MPI_COMM_RANK (MPI_COMM_WORLD, my_id, ierr)
      call MPI_COMM_SIZE (MPI_COMM_WORLD, num_procs, ierr)

      if (my_id .eq. root_process) then
c
c        I must be the root process, so I will query the user
c        to determine how many numbers to sum.

         print *, "please enter the number of numbers to sum:"
         read *, num_rows
         if ( num_rows .gt. max_rows) stop "Too many numbers."

         avg_rows_per_process = num_rows / num_procs

c        initialize a vector,

         do I = 1, num_rows
            vector(i) = float(i)
         end do

c        distribute a portion of the vector to each child process,

         do an_id = 1, num_procs -1
            start_row = ( an_id * avg_rows_per_process) + 1
            end_row = start_row + avg_rows_per_process - 1
            if (an_id .eq. (num_procs - 1)) end_row = num_rows
            num_rows_to_send = end_row - start_row + 1

            call MPI_SEND( num_rows_to_send, 1, MPI_INT, an_id, send_data_tag, MPI_COMM_WORLD, ierr)

            call MPI_SEND( vector(start_row), num_rows_to_send, MPI_REAL, an_id, send_data_tag, MPI_COMM_WORLD, ierr)
         end do

c        and calculate the sum of the values in the segment assigned 
c        to the root process,

         sum = 0.0
         do i = 1, avg_rows_per_process
            sum = sum + vector(i)
         end do

         print *, "sum ", sum, " calculated by root process."

c        and, finally, I collect the partial sums from slave processes,
c        print them, and add them to the grand sum, and print it.

         do an_id = 1, num_procs -1

            call MPI_RECV( partial_sum, 1, MPI_REAL, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)

            sender = status(MPI_SOURCE)
            print *, "partial sum ", partial_sum, " returned from process ", sender
            sum = sum + partial_sum 
         end do

         print *, "The grand total is: ", sum

      else

c        I must be a slave process, so I must receive my vector segment,
c        storing it in a "local" vector, vector2.  

         call MPI_RECV ( num_rows_to_receive, 1 , MPI_INT, root_process, MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)

         call MPI_RECV ( vector2, num_rows_to_received, MPI_REAL, root_process, MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)

         num_rows_received = num_rows_to_receive

c        Calculate the sum of my portion of the vector,

         partial_sum = 0.0
         do i = 1, num_rows_received
            partial_sum = partial_sum + vector2(i)
         end do

c        and, finally, send my partial sum to the root process.

         call MPI_SEND( partial_sum, 1, MPI_REAL, root_process,return_data_tag, MPI_COMM_WORLD, ierr)

      endif

c     Stop this process.

      call MPI_FINALIZE(ierr)
      stop
      end

