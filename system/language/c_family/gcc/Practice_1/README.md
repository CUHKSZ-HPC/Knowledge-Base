#GCC Compilation Process

### Exec the following command:
```
gcc main.c		# Compile main.c
```

```
gcc main.c -save-temps		# Compile main.c and keep temporary files
```

```
gcc main.c -E -o main.i		# Preprocess main.c to main.i
gcc main.i -S		# Compile main.i to main.s
gcc main.s -c		# Assemble main.s to main. o
gcc main.o		# link main.o to a.out
```


