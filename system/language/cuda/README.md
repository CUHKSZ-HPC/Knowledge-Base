# CUDA Tutorial

### Getting Start

To build and run CUDA programs, you need to ensure your computer has at least one NVIDIA graphic card and has the correct NVIDIA driver installed. To configure the development environment you can follow the useful materials.

After installed CUDA and setup the environment variables you can build CUDA source codes by 

```
$ nvcc ${source_file} -o ${output_file}
$ ${output_file}
===program output===
```

Also, you can use following `CMakeLists.txt` to build over multiple files

```cmake
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(a3 LANGUAGES C CUDA)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_FORCE_INLINES")

# set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message("Setting build type to 'Release' as none was specified.")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
endif()

# ========================================================================== #
# language standard requirements
# ========================================================================== #

if(NOT DEFINED CMAKE_C_STANDARD)
    set(CMAKE_C_STANDARD 11)
    set(CMAKE_C_STANDARD_REQUIRED true)
endif()

if(NOT DEFINED CMAKE_CUDA_STANDARD)
    set(CMAKE_CUDA_STANDARD 11)
    set(CMAKE_CUDA_STANDARD_REQUIRED true)
endif()

# ========================================================================== #
# compilation flags
# ========================================================================== #

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(CheckCCompilerFlag)

check_c_compiler_flag("-Wall" COMPILER_C_ALL_WARN)
if(COMPILER_C_ALL_WARN)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall"
        CACHE STRING "Show all warning messages" FORCE
    )
endif()

check_c_compiler_flag("-Wextra" COMPILER_C_EXTRA_WARN)
if(COMPILER_C_EXTRA_WARN)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wextra"
        CACHE STRING "Show extra warning messages" FORCE
    )
endif()

check_c_compiler_flag("-pipe" COMPILER_C_PIPE)
if(COMPILER_C_PIPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe"
        CACHE STRING "Speed up compilation by piping" FORCE
    )
endif()

set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -Xcompiler='${CMAKE_C_FLAGS}'"
    CACHE STRING "Pass the same C flags to back-end compiler of nvcc" FORCE
)

check_c_compiler_flag("-mavx" COMPILER_C_AVX)
if(COMPILER_C_AVX)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -mavx"
        CACHE STRING "Optimize with AVX instructions" FORCE
    )
endif()

check_c_compiler_flag("-mavx2" COMPILER_C_AVX2)
if(COMPILER_C_AVX2)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -mavx2"
        CACHE STRING "Optimize with AVX2 instructions" FORCE
    )
endif()

check_c_compiler_flag("-march=native" COMPILER_C_ARCH)
if(COMPILER_C_ARCH)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=native"
        CACHE STRING "Optimize based on the architecture" FORCE
    )
endif()

check_c_compiler_flag("-mtune=native" COMPILER_C_TUNE)
if(COMPILER_C_TUNE)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -mtune=native"
        CACHE STRING "Fine-tune the program based on the CPU" FORCE
    )
endif()

check_c_compiler_flag("-fomit-frame-pointer" COMPILER_C_NO_FP)
if(COMPILER_C_NO_FP)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fomit-frame-pointer"
        CACHE STRING "Omit frame pointers" FORCE
    )
endif()

check_c_compiler_flag("-ffast-math" COMPILER_C_FAST_MATH)
if(COMPILER_C_FAST_MATH)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -ffast-math"
        CACHE STRING "Trade floating point precision for speed" FORCE
    )
endif()

set(CMAKE_CUDA_FLAGS_RELEASE
    "${CMAKE_CUDA_FLAGS_RELEASE} -Xcompiler='${CMAKE_C_FLAGS_RELEASE}'"
    CACHE STRING "Pass the same C release flags to back-end compiler of nvcc"
    FORCE
)

# ========================================================================== #
# main program
# ========================================================================== #

set (CUDA_SRCS
    user_program.cu
    virtual_memory.cu
)

add_executable(${PROJECT_NAME}
    ${CUDA_SRCS}    
    main.cu
)

target_include_directories(${PROJECT_NAME}
    PRIVATE ${PROJECT_SOURCE_DIR}
    PRIVATE ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}    
)

add_library(lib
    ${CUDA_SRCS}
    virtual_memory.h    
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE lib
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    LINKER_LANGUAGE C
    CUDA_SEPARABLE_COMPILATION ON
)
```

Before getting deeper to the development of CUDA programs, one are highly suggested to figure out the CUDA memory management and CUDA hardware architecture first. There are several useful link under this tutorial to help you obtain the basic knowledge of GPU hardware architectures.

### Hello World.cu

```c++
__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main() {
    cuda_hello<<<1,1>>>(); 
    return 0;
}
```

### Use CUDA to Parallelize Your Program

Following is a simple CUDA program to add two vector's in sequential

```c++
void main(){
    float *a, *b, *out;
    float *d_a;

    a = (float*)malloc(sizeof(float) * N);

    // Allocate device memory for a
    cudaMalloc((void**)&d_a, sizeof(float) * N);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);

    …
    vector_add<<<1,1>>>(out, d_a, b, N);
    …

    // Cleanup after kernel execution
    cudaFree(d_a);
    free(a);
}
```

Next is the parallel version of the vector add program

```c++
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define N 10000000
#define MAX_ERR 1e-6

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    
    // Handling arbitrary vector size
    if (tid < n){
        out[tid] = a[tid] + b[tid];
    }
}

int main(){
    float *a, *b, *out;
    float *d_a, *d_b, *d_out; 

    // Allocate host memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Initialize host arrays
    for(int i = 0; i < N; i++){
        a[i] = 1.0f;
        b[i] = 2.0f;
    }

    // Allocate device memory 
    cudaMalloc((void**)&d_a, sizeof(float) * N);
    cudaMalloc((void**)&d_b, sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);


    // Executing kernel 
    int block_size = 256;
    int grid_size = ((N + block_size) / block_size);
    vector_add<<<grid_size,block_size>>>(d_out, d_a, d_b, N);
    
    // Transfer data back to host memory
    cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);

    // Verification
    for(int i = 0; i < N; i++){
        assert(fabs(out[i] - a[i] - b[i]) < MAX_ERR);
    }

    printf("PASSED\n");

    // Deallocate device memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);

    // Deallocate host memory
    free(a); 
    free(b); 
    free(out);
}
```

### Profiling CUDA programs

Using `time` does not give much information about the program performance. NVIDIA provides a command line profiler tool called `nvprof`, which give a more insight information of CUDA program performance.  

```bash
==6564== Profiling application: ./vector_add_grid
==6564== Profiling result:
Time(%)      Time     Calls       Avg       Min       Max  Name
 55.65%  20.312ms         2  10.156ms  10.150ms  10.162ms  [CUDA memcpy HtoD]
 41.24%  15.050ms         1  15.050ms  15.050ms  15.050ms  [CUDA memcpy DtoH]
  3.11%  1.1347ms         1  1.1347ms  1.1347ms  1.1347ms  vector_add(float*, float*, float*, int)
```

### Useful Materials

Get CUDA installed on Ubuntu 18.04

- https://www.pugetsystems.com/labs/hpc/How-to-install-CUDA-9-2-on-Ubuntu-18-04-1184/

Modern GPU architecture

- http://download.nvidia.com/developer/cuda/seminar/TDCI_Arch.pdf

Exploring the GPU architecture

- https://nielshagoort.com/2019/03/12/exploring-the-gpu-architecture/

CUDA memory model

- https://fenix.tecnico.ulisboa.pt/downloadFile/563568428758049/CUDA_3.pdf

CUDA tutorial

- https://cuda-tutorial.readthedocs.io/en/latest/tutorials/tutorial01/

CUDA toolkit document :

- https://docs.nvidia.com/cuda/archive/9.2/ (Refer to the version fits to your environment)

 CUDA programming introduction

- https://www.nvidia.com/content/cudazone/download/Getting_Started_w_CUDA_Training_NVISION08.pdf
- https://docs.nvidia.com/cuda/archive/9.2/cuda-c-programming-guide/index.html (Refer to the version of CUDA you installed.)