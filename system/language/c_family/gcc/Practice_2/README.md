# GCC Basic Parameters

### Exec the following command:
```
gcc main.c src/foo.c -I inc		# compile main.c & foo.c
```

```
gcc src/foo.c -c -I inc -o lib/foo.o		# compile foo.c to foo.o
ar rcs lib/libfoo.a lib/foo.o		# convert foo.o to libfoo.a (library)
gcc main.c -I inc -L lib -l foo		# compile main.c, link main.o & libfoo.a
```

```
gcc main.c src/foo.c -I inc -static		# statically complie main.c & foo.c
```
