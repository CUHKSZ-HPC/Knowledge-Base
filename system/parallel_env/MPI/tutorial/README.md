# Simple MPI tutorial

### Reference:

https://mpitutorial.com/tutorials/

https://blog.csdn.net/u014768676/article/details/45380795

https://www.mpich.org/static/docs/v3.1/

https://cloud.tencent.com/developer/ask/94180



### Setup

Open your terminal and cd to this dir. Then create a dir `build` for local compiled executable. 

```bash
$ cd /<your_work_dir_path>/Knowledge-Base/system/parallel_env/MPI/tutorial
$ mkdir build
```

---

### Env Check

Now please try to compile and run the `hello_mpi.cc`  to test if your MPI env is ready. Use the folowing command. You are expected to see something similar to the lines below in you terminal. 

```bash
$ mpicc hello_mpi.cc -o build/hello_mpi
$ mpirun -n 2 build/hello_mpi  # n stands for the number process to create
Hello world from processor <processor_name>, rank 1 out of 2 processors
Hello world from processor <processor_name>, rank 0 out of 2 processors
```

If you do, you are all set to move on. If not, try to check google with the error message or roll back to reinstall MPI releases. Now you have learned how to build a MPI program, use the similar code above to compile the MPI program or use the command below to check the content of the wrapper `mpicc` .

```bash
$ mpicc --showme
```



---

### Build MPI Program - hello_mpi.h

The first step to building an MPI program is including the MPI header files with `#include <mpi.h>`. After this, the MPI environment must be initialized with:

```C
MPI_Init(int* argc,
         char*** argv)
```

During `MPI_Init`, all of MPI’s global and internal variables are constructed. Currently, `MPI_Init`takes two arguments that are not necessary, and the extra parameters are simply left as extra space in case future implementations might need them. The `MPI_Finalize` and `MPI_Init` should come in pairs.  

```
MPI_Finalize()
```

`MPI_Finalize` is used to clean up the MPI environment, free the memory alloated. No more MPI calls can be made after this one. Now, you can write the MPI code between the `MPI_Finalize` and `MPI_Init` .

Generally, almost every MPI program needs to know the registered process size and which process you are in. The `MPI_Comm_size` and `MPI_Comm_rank` could give you the info needed. 

```C
MPI_Comm_size(MPI_Comm communicator,
              int* size)
```

```C
MPI_Comm_rank(MPI_Comm communicator,
              int* rank)
```

In addition, there's a function `MPI_Get_processor_name` to get the actual name of the processor on which the process is executing. On MacOS Mojave, the name is the host name. 

```C
MPI_Get_processor_name(char* name,
                       int* name_length)
```



---

### Blocking Point-to-Point Communication

#### MPI Send and Receive - send_recv.c

Sending and receiving are the two most important concepts of MPI. Almost every single function in MPI can be implemented with basic send and receive calls. I will discuss how to use MPI’s blocking sending and receiving functions, and I will also overview other basic concepts associated with transmitting data using MPI. The function references are shown below. 

```C
MPI_Send(void* data,
         int count,
         MPI_Datatype datatype,
         int destination,
         int tag,
         MPI_Comm communicator)
```

```C
MPI_Recv(void* data,
         int count,
         MPI_Datatype datatype,
         int source,
         int tag,
         MPI_Comm communicator,
         MPI_Status* status)
```

Note that the data stands for the initial location of the data, count is data length, datatype is MPI specified datatypes yet it can be defined by users. The source and destination could specify the communication pair and the tag could specify different information within one communication pair. At last, communicator specifys the communication domain. 

**Exercise**: try to read `example/ping_pong.c` see if you can understand what the programming is talking about. Then, try to add... say basketball using `tag` into the counting. 



#### MPI Status for dynamic message size - check_status.c

Note that the `MPI_Recv` operation takes the address of an `MPI_Status` structure as an argument (which can be ignored with `MPI_STATUS_IGNORE`). If we pass an `MPI_Status` structure to the `MPI_Recv`function, it will be populated with additional information about the receive operation after it completes. The three primary pieces of information include:

1. **The rank of the sender**. The rank of the sender is stored in the `MPI_SOURCE` element of the structure. That is, if we declare an `MPI_Status stat` variable, the rank can be accessed with `stat.MPI_SOURCE`.
2. **The tag of the message**. The tag of the message can be accessed by the `MPI_TAG` element of the structure (similar to `MPI_SOURCE`).
3. **The length of the message**. The length of the message does not have a predefined element in the status structure. Instead, we have to find out the length of the message with `MPI_Get_count`.

Using the `MPI_Status` structure + `MPI_Get_count` is an option for dynamic size message. 

```C
MPI_Get_count(MPI_Status* status,
              MPI_Datatype datatype,
              int* count)
```

`MPI_Recv`can take `MPI_ANY_SOURCE` for the rank of the sender and `MPI_ANY_TAG` for the tag of the message. For this case, the `MPI_Status` structure is the only way to find out the actual sender and tag of the message. Furthermore, `MPI_Recv` is not guaranteed to receive the entire amount of elements passed as the argument to the function call. Instead, it receives the amount of elements that were sent to it (and returns an error if more elements were sent than the desired receive amount). The `MPI_Get_count function` is used to determine the actual receive amount.



#### MPI_Probe for dynamic message size - probe.c

Instead of posting a receive and simply providing a really large buffer to handle all possible sizes of messages (as we did in the last example), you can use `MPI_Probe` to query the message size before actually receiving it. The function prototype looks like this.

```C
MPI_Probe(int source,
          int tag,
          MPI_Comm comm,
          MPI_Status* status)
```

`MPI_Probe` looks quite similar to `MPI_Recv`. In fact, you can think of `MPI_Probe` as an `MPI_Recv` that does everything but receive the message. Similar to `MPI_Recv`, `MPI_Probe` will block for a message with a matching tag and sender. When the message is available, it will fill the status structure with information. The user can then use `MPI_Recv` to receive the actual message.

**Exercise**: wrap up the `MPI_Recv` and `MPI_Probe` in a function for dynamic message receiving.



---

### Blocking Collective Communication

Collective communication is a method of communication which involves participation of **all** processes in a communicator. One of the things to remember about collective communication is that it implies a *synchronization point* among processes. This means that all processes must reach a point in their code before they can all begin executing again.

Before going into detail about collective communication routines, let’s examine synchronization in more detail. As it turns out, MPI has a special function that is dedicated to synchronizing processes:

```C
MPI_Barrier(MPI_Comm communicator)
```

The name of the function is quite descriptive - the function forms a barrier, and no processes in the communicator can pass the barrier until all of them call the function. 



#### MPI Broadcast - beast.c

A *broadcast* is one of the standard collective communication techniques. During a broadcast, one process sends the same data to all processes in a communicator. One of the main uses of broadcasting is to send out user input to a parallel program, or send out configuration parameters to all processes.

![MPI_Bcast pattern](https://mpitutorial.com/tutorials/mpi-broadcast-and-collective-communication/broadcast_pattern.png)

```C
MPI_Bcast(
    void* data,
    int count,
    MPI_Datatype datatype,
    int root,
    MPI_Comm communicator)
```

When the root process (in our example, it was process zero) calls `MPI_Bcast`, the `data` variable will be sent to all other processes. When all of the receiver processes call `MPI_Bcast`, the `data`variable will be filled in with the data from the root process.

**Exercise**: Use the `MPI_Send` and `MPI_Recv` to implement the `MPI_Bcast`. 



#### MPI Scatter - 

`MPI_Scatter` is a collective routine that is very similar to `MPI_Bcast`. `MPI_Scatter`involves a designated root process sending data to all processes in a communicator. The primary difference between `MPI_Bcast` and `MPI_Scatter`is small but important. `MPI_Bcast` sends the *same* piece of data to all processes while `MPI_Scatter` sends *chunks of an array* to different processes. Check out the illustration below for further clarification.

![MPI_Bcast vs MPI_Scatter](https://mpitutorial.com/tutorials/mpi-scatter-gather-and-allgather/broadcastvsscatter.png)

In the illustration, `MPI_Bcast` takes a single data element at the root process (the red box) and copies it to all other processes. `MPI_Scatter` takes an array of elements and distributes the elements in the order of process rank. The first element (in red) goes to process zero, the second element (in green) goes to process one, and so on. Although the root process (process zero) contains the entire array of data, `MPI_Scatter` will copy the appropriate element into the receiving buffer of the process.

```c
MPI_Scatter(void* send_data,
            int send_count,
            MPI_Datatype send_datatype,
            void* recv_data,
            int recv_count,
            MPI_Datatype recv_datatype,
            int root,
            MPI_Comm communicator)
```

The first parameter, `send_data`, is an array of data that resides on the root process. The second and third parameters, `send_count` and `send_datatype`, dictate how many elements of a specific MPI Datatype will be sent to each process. If `send_count` is one and `send_datatype` is `MPI_INT`, then process zero gets the first integer of the array, process one gets the second integer, and so on. If `send_count` is two, then process zero gets the first and second integers, process one gets the third and fourth, and so on. In practice, `send_count` is often equal to the number of elements in the array divided by the number of processes.



#### MPI Gather

`MPI_Gather` is the inverse of `MPI_Scatter`. Instead of spreading elements from one process to many processes, `MPI_Gather` takes elements from many processes and gathers them to one single process. This routine is highly useful to many parallel algorithms, such as parallel sorting and searching. Below is a simple illustration of this algorithm.

![MPI_Gather](https://mpitutorial.com/tutorials/mpi-scatter-gather-and-allgather/gather.png)

Similar to `MPI_Scatter`, `MPI_Gather` takes elements from each process and gathers them to the root process. The elements are ordered by the rank of the process from which they were received. 

```C
MPI_Gather(
    void* send_data,
    int send_count,
    MPI_Datatype send_datatype,
    void* recv_data,
    int recv_count,
    MPI_Datatype recv_datatype,
    int root,
    MPI_Comm communicator)
```

In `MPI_Gather`, only the root process needs to have a valid receive buffer. All other calling processes can pass `NULL` for `recv_data`. Also, don’t forget that the *recv_count* parameter is the count of elements received *per process*, not the total summation of counts from all processes. This can often confuse beginning MPI programmers.

**Exercise**: Try to use `MPI_Scatter` and `MPI_Gather` to compute the average of a array. 



#### MPI All Gather

Given a set of elements distributed across all processes, `MPI_Allgather` will gather all of the elements to all the processes. In the most basic sense, `MPI_Allgather` is an `MPI_Gather` followed by an `MPI_Bcast`. The illustration below shows how data is distributed after a call to `MPI_Allgather`.

![MPI_Allgather](https://mpitutorial.com/tutorials/mpi-scatter-gather-and-allgather/allgather.png)

Just like `MPI_Gather`, the elements from each process are gathered in order of their rank, except this time the elements are gathered to all processes. Pretty easy, right? The function declaration for `MPI_Allgather` is almost identical to `MPI_Gather` with the difference that there is no root process in `MPI_Allgather`.

```C
MPI_Allgather(
    void* send_data,
    int send_count,
    MPI_Datatype send_datatype,
    void* recv_data,
    int recv_count,
    MPI_Datatype recv_datatype,
    MPI_Comm communicator)
```

