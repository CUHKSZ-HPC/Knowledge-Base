# Fortran Start-up Guidance

### Overview

Fortran (Formula Translating System) is a general-purpose, imperative programming language. It is used for numeric and scientific computing.

Fortran was originally developed by IBM in the 1950s for scientific and engineering applications. Fortran ruled this programming area for a long time and became very popular for high performance computing, because.

It supports:

+ Numerical analysis and scientific computation
+ Structured programming

- Array programming
- Modular programming
- Generic programming
- High performance computing on supercomputers
- Object oriented programming
- Concurrent programming
- Reasonable degree of portability between computer systems

### Environment Setup: 

You can refer to the attached website for tips on setting up the environment:

+ For Mac users: https://www.math.fsu.edu/~sussman/fortran-tips/

+ For Win users: https://www.webmo.net/support/fortran_osx.html

## Basic Syntax:



#### ‘Hello World’:

```fortran
program main

 implicit none

 write(*,*) "Hello World!"

end 
```



#### Add Numbers:

```fortran
program addNumbers

! This simple program adds two numbers

  implicit none
  
! Type declarations

  real :: a, b, result

! Executable statements

  a = 12.0

  b = 15.0

  result = a + b

  print *, 'The total is ', result

end program addNumbers
```

#### Sorting Computer:

```fortran
Insertion Sort:

PROGRAM SORT1

real  A(100)   !Table to be sorted

real  MAX_VALUE !Maximum value of table

integer Count(1)  !Current value of system clock

 !initialize random number generator

 call System_Clock(Count(1))

 call Random_Seed(Put=Count)

 N=25 !initialize size of table

 MAX_VALUE = 1000

 !generate random table of numbers (from 0 to 1000)

 do i=1, N

  call Random_Number(x) !returns random x >= 0 and <1 

  A(i)=MAX_VALUE*x

 end do

 print *,' '

 print *,'Table to be sorted:'

 call TWRIT(N,A)

 

 !call sorting subroutine

 call PIKSRT(N,A)

 

 print *,' '

 print *,'Sorted table (straight insertion):'

 call TWRIT(N,A)

 print *,' '

 stop

END
```

# Fortran MPI Tutorial

A guidance for beginners to use MPI on Fortran

## Simple Introduction

Fortran was developed by a team at IBM in 1957 for scientific calculations. It is an extremely old programming language as a stance in 2019. The name Fortran stands for FORmula TRANslator. Since it is originally designed for scientific computation, it had very limited support for character strings and other data structures need for general purpose programming. 

Why we still need to learn Fortran in 2019? For me, the foremost reason is there still remains lots of high performance programs written in Fortran. As a parallel program developer, learning Fortran is *somehow essential in understanding those programs written in Fortran*. One might outperform the software optimization skills benefited from basic knowledge in Fortran programming.

Message Passing Interface (MPI) is a standard with support of several modern programming languages such as C/C++ and Python. Fortunately, in Fortran programmers can also write parallel programs in MPI. In this tutorial we will be using the GNU Fortran Compiler and OpenMPI to create multiprocess programs in Fortran. 

Readers are recommended to have MPI programming experience on at least one programming language.

---

## Environment Setup

1. Install gfortran and OpenMPI on Ubuntu 18.04

   `$ sudo apt install gfortran MPICH`

2. Compile Fortran using mpifort

   `$ mpifort -fc=gfortran ${source} -o ${output}`
   
3.  Execute the output program using mpirun

   `$ mpirun -np ${process_num} ${output}`

---

## Basic Function Calls

| Function                              | Description                                                  |
| ------------------------------------- | ------------------------------------------------------------ |
| *MPI_INIT(&ierr)*                     | Initialize the MPI environment                               |
| *MPI_COMM_SIZE(&group, &size, &ierr)* | Return the quantity of processes                             |
| *MPI_COMM_RANK(&group, &rank, &ierr)* | Return the rank of the process calling this function         |
| *MPI_FINALIZE(&ierr)*                 | Cleans up the MPI environment and ends MPI communications    |
| *MPI_BARRIER(&ierr)*                  | Wait for other processes to reach this line of code and continue execution if all processes have reached the barrier |

#### HelloWorld.f90

`sample_code/HelloWorld.f90` shows the basic usage of these five functions. 

```fortran
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
```

The output after running HelloWorld.f90 is as following

```
$ mpirun -np 10 ./a.out
Hello World from process:            0 of           10
Hello World from process:            1 of           10
Hello World from process:            2 of           10
Hello World from process:            3 of           10
Hello World from process:            4 of           10
Hello World from process:            5 of           10
Hello World from process:            6 of           10
Hello World from process:            8 of           10
Hello World from process:            7 of           10
Hello World from process:            9 of           10
```

---

## Message Passing

### Send and Receive

MPI provides several functions for one process to communicate with other processes. Two essential functions are 

| Function                                                     | Description                                         |
| ------------------------------------------------------------ | --------------------------------------------------- |
| *MPI_SEND(data, send_count, data_type, dest, tag, comm, ierr)* | Send *send_count* amount of *data* to *dest*        |
| *MPI_RECV(data, receive_count, data_type, src, tag, comm, status, ierr)* | Receive *receive_count* amount of *data* from *src* |

### MPI Data Types

| MPI Data Type        | Fortran Generic Data Type |
| -------------------- | ------------------------- |
| MPI_INTEGER          | INTEGER                   |
| MPI_REAL             | REAL                      |
| MPI_DOUBLE_PRECISION | DOUBLE_PRECISION          |
| MPI_COMPLEX          | COMPLEX                   |
| MPI_LOGICAL          | LOGICAL                   |
| MPI_CHARACTER        | CHARACTER                 |
| MPI_BYTE             |                           |
| MPI_PACKED           |                           |

`sample_code/SumVector.f90` shows how to use MPI_SEND and MPI_RECV to sum a vector in parallel

```fortran
PROGRAM sum_vector_mpi
include "mpif.h"

PARAMETER (max_rows = 10000000)
PARAMETER (send_data_tag = 2001, return_data_tag = 2002)

INTEGER my_id, root_process, ierr, status(MPI_STATUS_SIZE)
INTEGER num_procs, an_id, num_rows_to_receive 
INTEGER avg_rows_per_process, num_rows, num_rows_to_send
REAL vector(max_rows), vector2(max_rows), partial_sum, sum
root_process = 0

CALL MPI_INIT (ierr)
CALL MPI_COMM_RANK (MPI_COMM_WORLD, my_id, ierr)
CALL MPI_COMM_SIZE (MPI_COMM_WORLD, num_procs, ierr)

IF (my_id .eq. root_process) THEN

PRINT *, "please enter the number of numbers to sum:"
READ *, num_rows
IF ( num_rows .gt. max_rows) STOP "Too many numbers."

avg_rows_per_process = num_rows / num_procs

DO I = 1, num_rows
    vector(i) = float(i)
END DO

DO an_id = 1, num_procs -1
    start_row = ( an_id * avg_rows_per_process) + 1
    end_row = start_row + avg_rows_per_process - 1
    IF (an_id .eq. (num_procs - 1)) end_row = num_rows
        num_rows_to_send = end_row - start_row + 1
        CALL MPI_SEND( num_rows_to_send, 1, MPI_INT,
&      an_id, send_data_tag, MPI_COMM_WORLD, ierr)
        CALL MPI_SEND( vector(start_row), num_rows_to_send, MPI_REAL, 
&      an_id, send_data_tag, MPI_COMM_WORLD, ierr)
END DO

sum = 0.0
DO i = 1, avg_rows_per_process
    sum = sum + vector(i)
END DO

PRINT *, "sum ", sum, " calculated by root process."

DO an_id = 1, num_procs -1
CALL MPI_RECV( partial_sum, 1, MPI_REAL, MPI_ANY_SOURCE,
&          MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)

    sender = status(MPI_SOURCE)
    print *, "partial sum ", partial_sum, 
&             " returned from process ", sender
    sum = sum + partial_sum 
END DO
PRINT *, "The grand total is: ", sum
ELSE
    CALL MPI_RECV ( num_rows_to_receive, 1 , MPI_INT,
&     root_process, MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)
    CALL MPI_RECV ( vector2, num_rows_to_received, MPI_REAL, 
&     root_process, MPI_ANY_TAG, MPI_COMM_WORLD, status, ierr)

num_rows_received = num_rows_to_receive

partial_sum = 0.0
DO i = 1, num_rows_received
    partial_sum = partial_sum + vector2(i)
END DO

CALL MPI_SEND( partial_sum, 1, MPI_REAL, root_process,
&      return_data_tag, MPI_COMM_WORLD, ierr)

ENDIF
CALL MPI_FINALIZE(ierr)
STOP
END
```

