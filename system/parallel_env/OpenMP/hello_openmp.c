#include "hello_openmp.h"

#include <stdio.h>
#include <time.h>
#include <omp.h>

int main() {
  omp_allthreads();
  printf("------------------------------\n");
  omp_threads(3);
  printf("------------------------------\n");
  omp_for();
  printf("------------------------------\n");
  omp_time();
  printf("------------------------------\n");
  omp_parallel_section();
  return 0;
}


// This an example of parallel one syntax using the max number of threads.
void omp_allthreads() {
  #pragma omp parallel
  {
    printf("%s", "Hello World!\n");
  }
}

// This an example of parallel one syntax using the specified number of threads.
void omp_threads(int num_thread) {
  #pragma omp parallel num_threads(num_thread) 
  {
    printf("%s", "Hello World!\n");
  }
}

// This is an example for parallel the for loop using omp.
// Notice the constrains of using 
void omp_for() {
  #pragma omp parallel for
  for (char i = 'a'; i <= 'z'; i++) {
    printf("%c \n", i);
  }
}

// Note that private marks i as the independet copy for every thread. 
// The time measuring method is used
void omp_time() {
  int i, nthreads;
  clock_t clock_timer;
  double wall_timer;
  double c[1000000];
  for (nthreads = 1; nthreads <=6; ++nthreads) {
    clock_timer = clock();
    wall_timer = omp_get_wtime();
    #pragma omp parallel for private(i) num_threads(nthreads)
    for (i = 0; i < 1000000; i++) {
      c[i] = (i * 4 + i * 2 + i) * (i * 4 + i * 2 + i);
    }
    printf("threads: %d time on clock(): %f time on wall: %f\n", 
            nthreads, 
            (double) (clock() - clock_timer) / CLOCKS_PER_SEC, 
            omp_get_wtime() - wall_timer);
  }
}

// This shows the detailed control of OpenMP, teh sections are all run in parallel.
// Every section is on one thread. 
void omp_parallel_section() {
  #pragma omp parallel
  {
    printf("All threads run this\n");
    #pragma omp sections
    {
      #pragma omp section
      {
        printf("This executes in parallel\n");
      }
      #pragma omp section
      {
        printf("Sequential statement 1\n");
        printf("This always executes after statement 1\n");
      }
      #pragma omp section
      {
        printf("This also executes in parallel\n");
      }
    }
  }
}
