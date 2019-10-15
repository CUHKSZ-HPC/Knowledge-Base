# A simple Installation guidance for HPL(High Performance Linpack)

### Related Website:
* [Installation Reference -> HPL (High Performance Linpack): Benchmarking Raspberry PIs](https://www.howtoforge.com/tutorial/hpl-high-performance-linpack-benchmark-raspberry-pi/)
* [HPL Release -> HPL - A Portable Implementation of the High-Performance Linpack Benchmark for Distributed-Memory Computers](https://www.netlib.org/benchmark/hpl/)


### Installation Environment:
    Ubuntu 18.04.2 LTS, 4.18.0-15-generic, x86_64, VirtualBox

### 0. Install dependency
    sudo apt-get install -y libatlas-base-dev libmpich-dev gfortran

### 1. Download HPL
    cd ~
    wget https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz
    mv hpl-2.3 hpl

### 2. Generate HPL template conffile
    cd hpl/setup
    sh make_generic
    cp Make.UNKNOWN ../Make.linux
    cd ../

### 3. Modify Make.linux according to the text below
    ARCH         = linux
    MPinc        = /usr/include/mpich/                      # dpkg --listfiles libmpich-dev | grep 'mpi\.h'
    MPlib        = /usr/lib/x86_64-linux-gnu/libmpich.so    # dpkg --listfiles libmpich-dev | grep 'libmpich.so'
    LAinc        = /usr/include/x86_64-linux-gnu/atlas      # dpkg --listfiles libatlas-base-dev | grep 'atlas_buildinfo\.h'

### 4. Compile HPL
    make arch=linux -j $(nproc)

### 5. Modify HPL.dat and run the HPL
    cd bin/linux

##### Replace HPL.dat by the text below:
	HPLinpack benchmark input file
	Innovative Computing Laboratory, University of Tennessee
	HPL.out      output file name (if any)
	6            device out (6=stdout,7=stderr,file)
	1            # of problems sizes (N)
	5040         Ns
	1            # of NBs
	128          NBs
	0            PMAP process mapping (0=Row-,1=Column-major)
	1            # of process grids (P x Q)
	1            Ps
	1            Qs
	16.0         threshold
	1            # of panel fact
	2            PFACTs (0=left, 1=Crout, 2=Right)
	1            # of recursive stopping criterium
	4            NBMINs (>= 1)
	1            # of panels in recursion
	2            NDIVs
	1            # of recursive panel fact.
	1            RFACTs (0=left, 1=Crout, 2=Right)
	1            # of broadcast
	1            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
	1            # of lookahead depth
	1            DEPTHs (>=0)
	2            SWAP (0=bin-exch,1=long,2=mix)
	64           swapping threshold
	0            L1 in (0=transposed,1=no-transposed) form
	0            U  in (0=transposed,1=no-transposed) form
	1            Equilibration (0=no,1=yes)
	8            memory alignment in double (> 0)
##### Execute HPL program
    ./xhpl

##### The output will be something like:
	================================================================================
	HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
	Written by A. Petitet and R. Clint Whaley,  Innovative Computing Laboratory, UTK
	Modified by Piotr Luszczek, Innovative Computing Laboratory, UTK
	Modified by Julien Langou, University of Colorado Denver
	================================================================================

	An explanation of the input/output parameters follows:
	T/V    : Wall time / encoded variant.
	N      : The order of the coefficient matrix A.
	NB     : The partitioning blocking factor.
	P      : The number of process rows.
	Q      : The number of process columns.
	Time   : Time in seconds to solve the linear system.
	Gflops : Rate of execution for solving the linear system.

	The following parameter values will be used:

	N      :    5040 
	NB     :     128 
	PMAP   : Row-major process mapping
	P      :       1 
	Q      :       1 
	PFACT  :   Right 
	NBMIN  :       4 
	NDIV   :       2 
	RFACT  :   Crout 
	BCAST  :  1ringM 
	DEPTH  :       1 
	SWAP   : Mix (threshold = 64)
	L1     : transposed form
	U      : transposed form
	EQUIL  : yes
	ALIGN  : 8 double precision words

	--------------------------------------------------------------------------------

	- The matrix A is randomly generated for each test.
	- The following scaled residual check will be computed:
		  ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
	- The relative machine precision (eps) is taken to be               1.110223e-16
	- Computational tests pass if scaled residuals are less than                16.0

	================================================================================
	T/V                N    NB     P     Q               Time                 Gflops
	--------------------------------------------------------------------------------
	WR11C2R4        5040   128     1     1               9.86             8.6634e+00
	HPL_pdgesv() start time Tue Oct 15 15:19:01 2019

	HPL_pdgesv() end time   Tue Oct 15 15:19:10 2019

	--------------------------------------------------------------------------------
	||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   2.33978261e-03 ...... PASSED
	================================================================================

	Finished      1 tests with the following results:
		          1 tests completed and passed residual checks,
		          0 tests completed and failed residual checks,
		          0 tests skipped because of illegal input values.
	--------------------------------------------------------------------------------

	End of Tests.
	================================================================================
