## Shell Basic

Shell is a scripting language basicly used for communicating with operating system. It is always used to avoid duplicated work. For shell in linux, you need to be familiar with the commands in the linux system. But there are some differences between shell and other language.

Here are some simple commands that are useful in shell. For advanced learning like pipeline operations, please read the manual.

### Usefull Website (advanced learning)

 * [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)

---

### Variable

There are three kinds of variables in shell:
    
    1. local variable, using only in the current script
    2. environmental variable, using in the program started by the program
    3. shell variable, this is the variable setted by shell program. some of the variable is environment variable, some of them are local varaible. These variables ensure shell's normally running


Shell String:
    
* using single quote as a string or use no quote, double quote will allow variable inside.

```shell script
    a=name
    echo $a a #print out "name a"

    # getting the length of the string:    
    string=abcd
    echo ${#string}
    
    # getting the index of the assigned string:
    a='hello cuhksz'
    echo `expr index "$a" lo` # print out 3
```


---

### Comparator

Here are some of the comparator:
* -eq
* -ne
* -gt
* -ge
* -lt
* -le

```shell script
    (( $a -eq $b )) && echo "..." || echo "blah"
```

### Calculation
    
* There are two way to to the calculation in shell.
    1. calculate using another layer of ()
    
        ``` shell script
            echo $((1==2))
        ```
    
    2. calculate and assign value using let
        ``` shell script
            let c=1+2
        ```
       
* operation as followed:
        
        add: +
        subtract: -
        multiply: *
        divide: /
        remain: %
        power: **

#### Tuple

```shell script
    tuple=(0 1 2 3 4 5)

    echo ${#tuple[@]} #length of the tuple

    echo ${tuple[n]} # print the element at specific location

    let a=${#tuple[@]}-1
    for i in `seq 0 $a` # use the element one by one
        do
            echo ${tuple[$i]}
        done
```


#### If Else

Using if clause:
    
The if clause is a little bit different from other language. This is the template of using if else in shell:
```shell script
    if [ expression1 ]; then # remember to leave a space in the front and in the end of the clause
        echo "first element"
    elif [ expression2 ]; then
        echo "second element"
    else
        echo "third element"
    fi
```

Example:

```shell script
    a=1
    b=2
    if [ $a == "1" ]; then echo "$a"; else echo "$b"; fi # print out 1
```

A faster way to do the comparison:
```shell script
    (( $a==1 )) && echo "ok" || echo "no" # echo ok
```

#### For loop

Passing variable: 
```shell script
    for file in $(ls)
        do
            echo $file #print all the variable return from ls
        done
    
    for i in `seq 1 100`
        do
            echo $i # print all variable form 1 to 100
        done
```

### While Loop

Template:
```shell script
    while [ $a -lt number ] 
    do 
        echo "result not qualified"
        let a--
    done
```

### Some actual usage in production
 ```shell script
#stop the running application
tmux has-session -t backend
if (($? == 0))
then
        ./stop.sh
fi

# pulling from git
echo "pulling from git"
cd model_backend
git add .
git commit -m "server local changes"
git pull origin master
mvn clean package
echo "code refreshed"
cd ..

#deploying
echo "starting a new session"
tmux new -s backend -d

echo "run the program"
tmux send -t "backend" "./start-application.sh" Enter

```
