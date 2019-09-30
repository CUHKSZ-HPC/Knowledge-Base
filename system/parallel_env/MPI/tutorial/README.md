# Simple MPI tutorial

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
$ mpirun -n 2 ./build/hello_mpi  # n stands for the number process to create
Hello world from processor <host_name_if_using_mac>, rank 1 out of 2 processors
Hello world from processor <host_name_if_using_mac>, rank 0 out of 2 processors
```

If you do, you are all set to move on. If not, try to check google with the error message or roll back to reinstall MPI releases. 

---

