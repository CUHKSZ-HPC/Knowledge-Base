# GCC Basic Parameters

### Exec the following command:
```
gcc main.c src/foo.c -I inc
```

```
gcc src/foo.c -c -I inc -o lib/foo.o
ar rs lib/libfoo.a lib/foo.o
gcc main.c -I inc -L lib -l foo
```


