# A GCC Arguments Cheat Sheet

### Compilation Related Tool

* cpp - The C Preprocessor
* gcc - GNU project C and C++ compiler
* as - The portable GNU assembler
* ld - The GNU linker

---

* ar - create, modify, and extract from archives
* ln - make links between files

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
* .out - ELF Shared Object, dynamically linked (Dynamic Library, Executable)
* .out - ELF Shared Object, statically linked (Dynamic Library, Executable)

### GCC Compilation Process
![graph](https://www3.ntu.edu.sg/home/ehchua/programming/cpp/images/GCC_CompilationProcess.png)
* Preprocessing(cpp):  `-E`
* Compilationz(gcc):   `-S`
* Assemble(as):        `-c`
* Linking(ld):         `(default)`
* Save All Temps File: `-save-temps`

### GCC Basic Arguments
* Output File Name:  `-o <file>`
* Header Directory:  `-I src`
* Library Directory: `-L lib`
* Linking Library:   `-l foo`
* Create Static Library: `ar rcs libfoo.a foo.o`

### GCC Advanced Arguments
* Include Warning:          `-Wall`
* Display Invoked Program:  `-v`
* Pass arg to Preprocessor: `-Wp,<options>`
* Pass arg to Assembler:    `-Wa,<options>`
* Pass arg to Linker:       `-Wl,<options>`

### GCC Dynamic Linking
* All Library Static Linking: `-static`
* Create Shared Object: `-shared`
* Create Position Independent Code: `-fPIC`
* Set Runtime Shared Library Search Path: `-Wl,-rpath <Path>` 
