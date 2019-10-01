

# MPI - Message Passing Interface

### Overview

The first question is what is MPI and what's the use of it? MPI is a standard for process communication. Generally the parallel processs would not share memory with each other. Hence, to enable communication for programs running on non-shared storage distributed system, the MPI standard is needed. 

Knowing that MPI is a standard, a protocal, then there's many ways to implement it. The most widly used releases are **MPICH, Open-MPI, Intel-MPI, MVAPICH**. The difference among the implementations are huge. Some of them are highly encapsulated and some of them are more open; some of them supports InfiniBand while some of then does not. The difference would be discussed in the later update. 

[Official Doc for MPICH](https://www.mpich.org/documentation/guides/)

[Official Doc for Open-MPI](https://www.open-mpi.org/doc/)

[Official Doc for Intel-MPI](https://software.intel.com/en-us/mpi-library/documentation/get-started)

[Official Doc for MVAPICH](http://mvapich.cse.ohio-state.edu/userguide/)

---

### File Structure

```
|-README.md  // This is what you are looking at
|-tutorial  // This is for beginners to practice
	+-README.md
	+-hello_mpi.cc
|-example_code  // The excellent code for example use
```

If you are new to HPC and new to MPI, PLEASE CHECK the tutorial first as a start. If you are an expert, feel free to skip or contribute to this part. The `example_code` is open for ALL great MPI code for now, upload your own code for others to reference. 

---

### Installation

For personal practice, the MPI release is up to your choice, but generally **MPICH** and **Open-MPI** are recommended because of the popularity and simplicity. 

If you are a Mac user, `brew` is not recommended due to some strange config error(you can try it though). Instead, try to follow 

[OpenMPI for MacOS](https://stackoverflow.com/questions/42703861/how-to-use-mpi-on-mac-os-x)

[MPICH for MacOS](https://scorec.rpi.edu/~littld/osx_mpich_1.2.6.html)

If you are a Windows user, try to use **MS-MPI** or **Intel-MPI** since **MPICH** or **Open-MPI** is not supported by Windows (you can challange youself though)

[MS-MPI for Win10](https://docs.microsoft.com/en-us/message-passing-interface/microsoft-mpi)

[Intel-MPI for Win10](https://www.xlsoft.com/jp/products/intel/cluster/mpi/32/win/Installation_Guide.htm)

If you are a Linux user(Hail Linus), try to follow

[Open-MPI for Linux](https://github.com/firemodels/fds/wiki/Installing-Open-MPI-on-a-Linux-Cluster)

[MPICH for Linux](https://mpitutorial.com/tutorials/installing-mpich2/)

[Intel-MPI for Linux](https://scc.ustc.edu.cn/zlsc/tc4600/intel/2017.0.098/mpi/INSTALL.html)