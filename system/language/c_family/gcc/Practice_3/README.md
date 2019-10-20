# GCC Dynamic Linking

### Exec the following command:
```
gcc src/foo.1.c -I inc -shared -fPIC -o lib/libfoo.so.1
ln -sf $(pwd)/lib/libfoo.so.1 $(pwd)/lib/libfoo.so
gcc main.c -I inc -L lib -lfoo -Wl,-rpath=$(pwd)/lib
./a.out

gcc src/foo.2.c -I inc -shared -fPIC -o lib/libfoo.so.2
ln -sf $(pwd)/lib/libfoo.so.2 $(pwd)/lib/libfoo.so
./a.out
```


