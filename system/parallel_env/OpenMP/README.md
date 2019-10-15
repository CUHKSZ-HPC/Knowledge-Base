## OpenMP

OpenMP is a multi-threading shared-memory-space model. To learn OpenMP, you first need to understand the POSIX Thread since OpenMP is build on PThread and the ideas used PThread could be infered on OpenMP.  Since we are using Linux, gcc is recommended as the primiary compiler and it natively supports OpenMP. 

The recommended learning scheme is go throught this doc and code provided first to gain the first impression, then go through the line below. 

Official Website: https://www.openmp.org

Instruction collection: [english-official](https://www.openmp.org/specifications/) [chinese-csdn](https://blog.csdn.net/ArrowYL/article/details/81094837) 

learning resource: [resource collection](https://blog.csdn.net/longji/article/details/95076143) [recommended guide](https://blog.csdn.net/augusdi/article/category/1394219) [practice code 1](https://blog.csdn.net/jinshengtao/article/details/79120067) [practice code 2](https://github.com/5455945/cpp_demo/tree/master/OpenMP/src)



### Hello World

---

Compile and run the given program to gain a basic idea on OpenMP. 

```bash
$ mkdir build
$ gcc hello_openmp.c hello_openmp.h -fopenmp -o build/hello_openmp
$ ./build/hello_openmp
...
```

Check the functions in the `hello_openmp.c` . you can have a basic understanding of the OpenMP. 



### Critical Section

---

OpenMP provides critical section. 

```c
#pragma omp critical (optional section name)
{
// no 2 threads can execute this code block concurrently
}
```

However, the mutex lock is also provided. 

`omp_lock_t`: It's defined as part of the `omp.h`. Meanwhile, `pthread` style implementation is also supported using the API provided： 

- **`omp_init_lock`**：This should be the first thing to execute for initialization and after this, the lock is not set as on. 
- **`omp_destroy_lock`**：This is used at the end and the lock has to be off when calling this, which means you can't call this right after `omp_set_lock`.  
- **`omp_set_lock`**：This sets  `omp_lock_t` and you will have mutex env. I thread would wait until the lock is off. 
- **`omp_test_lock`**：This is the non-blocking version of `omp_set_lock`. It would try to set the lock and return 1 when success and return 0 when fail. 
- **`omp_unset_lock`**：This is used to unset the lock.

In addition, there's nest lock, check it your self if you are interested. 

