#GCC Compilation Process

### Exec the following command:
```
gcc main.c
```

```
gcc main.c -save-temps
```

```
gcc main.c -E -o main.i
gcc main.i -S 
gcc main.s -c
gcc main.o
```


