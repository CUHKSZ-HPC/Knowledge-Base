# GCC Dynamic Linking

### Exec the following command:
```
gcc src/foo.1.c -I inc -shared -fPIC -o lib/libfoo.so.1		# Compile foo.1.c as dynamic library
ln -sf $(pwd)/lib/libfoo.so.1 $(pwd)/lib/libfoo.so		# Create soft link libfoo.so to libfoo.so.1
gcc main.c -I inc -L lib -lfoo -Wl,-rpath=$(pwd)/lib		# Compile main.c, link main.o & libfoo.so
./a.out

gcc src/foo.2.c -I inc -shared -fPIC -o lib/libfoo.so.2		# Compile foo.2.c as dynamic library
ln -sf $(pwd)/lib/libfoo.so.2 $(pwd)/lib/libfoo.so		# Create soft link libfoo.so to libfoo.so.2
./a.out
```


