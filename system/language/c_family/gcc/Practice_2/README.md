# GCC Basic Parameters

### Exec the following command:
```
gcc main.c src/foo1.c src/foo2.c -I inc		# compile main.c & foo1.c & foo2.c
```

```
gcc main.c src/foo1.c src/foo2.c -I inc -static		# statically complie main.c & foo1.c & foo2.c
```

```
gcc src/foo1.c -c -I inc -o lib/foo1.o		# compile foo1.c to foo1.o
gcc src/foo2.c -c -I inc -o lib/foo2.o		# compile foo2.c to foo2.o
ar rcs lib/libfoo.a lib/foo1.o lib/foo2.o		# Add foo1.o & foo2.o to libfoo.a (library)
gcc main.c -I inc -L lib -lfoo		# compile main.c, link main.o & libfoo.a
```

```
gcc src/foo1.c -c -I inc -o lib/foo1.o
gcc src/foo2.c -c -I inc -o lib/foo2.o
ar rcs lib/libfoo.a lib/foo1.o lib/foo2.o
gcc -lfoo main.c -I inc -L lib		# link order matters
```

