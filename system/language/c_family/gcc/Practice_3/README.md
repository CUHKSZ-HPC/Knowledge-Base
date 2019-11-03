# GCC Dynamic Linking

### Exec the following command:
```
gcc src/foo.1.c -I inc -shared -fPIC -o lib/libfoo.so.1		# Compile foo.1.c as dynamic library
ln -sf libfoo.so.1 lib/libfoo.so		# Create soft link libfoo.so to libfoo.so.1
gcc main.c -I inc -L lib -lfoo -Wl,-rpath=$(pwd)/lib		# Compile main.c, link main.o & libfoo.so
./a.out

gcc src/foo.2.c -I inc -shared -fPIC -o lib/libfoo.so.2		# Compile foo.2.c as dynamic library
ln -sf libfoo.so.2 lib/libfoo.so		# Create soft link libfoo.so to libfoo.so.2
./a.out
```

* `gcc src/foo.1.c -I inc -shared -fPIC -o lib/libfoo.so.1`\
	is equivalent to\
	`gcc src/foo.1.c -I inc -fPIC -c` 
	+\
	`gcc foo.1.o -shared -o lib/libfoo.so.1`
