# A GCC Arguments Cheat Sheet

### Compilation Related Tool

* cpp - The C Preprocessor
* gcc - GNU project C and C++ compiler
* as - The portable GNU assembler
* ld - The GNU linker

---

* ar - create, modify, and extract from archives

    * `ar rcs ARCHIVE [MEMBER...]`\
    Create `ARCHIVE` from `MEMBER`s
* ln - make links between files

    * `ln -sf TARGET LINK_NAME`\
    Create `LINK_NAME` linking to `TARGET`\
    If `TARGET` is a relative path, then it is interpreted relative to `LINK_NAME`

---

* readelf - Displays information about ELF files
* ldd - Print shared object dependencies
* nm - list symbols from object files
* objdump - display information from object files

### Compilation Related File
* .c - C Source Code
* .h - C Header Code
* .i - C Source Code (Preprocessed)
* .s - Assembler Source Code
* .o - ELF relocatable
* .a - ar Archive (Static Library)
* .so - ELF Shared Object, dynamically linked (Shared Library)
* .out - ELF Shared Object, dynamically linked (Executable)
* .out - ELF Shared Object, statically linked (Executable)

|                | statically linked | dynamically linked |
| ---------------| :---------------: | :----------------: |
| static library | √                 | ×                  |
| shared library | √(partial)        | √                  |

> You can't statically link shared library or dynamically link static

> Flag `-static` will force linker to use static library (.a) instead of shared (.so) But. Static libraries not always installed by default. So if you need static link you have to install static libraries.

### Compilation Related Directory
#### Compiler Path
* /usr/lib/gcc/x86_64-linux-gnu/`$(gcc --version)`/
#### Library Path
* /usr/lib/x86_64-linux-gnu/
#### Include Path
* /usr/include
* /usr/lib/gcc/x86_64-linux-gnu/7/include
* `$(pwd)`

### GCC Compilation Process
![graph](https://www3.ntu.edu.sg/home/ehchua/programming/cpp/images/GCC_CompilationProcess.png)
* Preprocessing(cpp):  `-E`
* Compilationz(gcc):   `-S`
* Assemble(as):        `-c`
* Linking(ld):         `(default)`
* Save All Temps File: `-save-temps`

### GCC Info Arguments
* Display Invoked Program: `-v`
    * cpp -v /dev/null -o /dev/null 2>&1
* Display search path: `-print-search-dirs`
* Display path to library: `-print-file-name=<lib>`
    * gcc -print-file-name=libpthread.so
* Print the ld input files: `-Wl,--trace`

### GCC Basic Arguments
* Output File Name:  `-o <file>`
* Header Directory:  `-I <dir>`
* Library Directory: `-L <dir>`
* Linking Library:   `-l<lib>`
    * `-lfoo` is equivalent to `-l:libfoo.so` or `-l:libfoo.a`
    * __link order matters__
* Create Static Library: `ar rcs libfoo.a foo.o`

### GCC Advanced Arguments
* Enable all Warning msg:    `-Wall`
* Pass arg to Preprocessor: `-Wp,<options>`
* Pass arg to Assembler:    `-Wa,<options>`
* Pass arg to Linker:       `-Wl,<options>`
* Generate more debugging info for gdb: `-g`
* Set Optimization Level:   `-O<level>`
* Define a macro: `-D <name>`
    * or `-D <name>=<value>`

### GCC Dynamic Linking
* All Library Static Linking: `-static`
* Create Position Independent Code: `-fPIC`
* Create Shared Object: `-shared`
* Set Runtime Shared Library Search Path: `-Wl,-rpath <Path>`
    [About Static and Shared Libraries: 1.8](https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html)
