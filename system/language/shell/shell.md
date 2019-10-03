Shell Basic

    Shell is basicly used for communicating with operating system.
    
    It is always used to avoid duplicated work.
    
    For shell in linex, you need to be familiar with the commands in the linux system. But there are some differences between shell and other language.
        
Variable:
    
    There are three kinds of variables in shell:
        1. local variable, using only in the current script
        2. environmental variable, using in the program started by the program
        3. shell variable, this is the variable setted by shell program. some of the variable is environment variable, some of them are local varaible. These variables ensure shell's normally running
    
    Shell String:
        using single quote as a string or use no quote
         
            a=name
            echo $a a #print out "name a"
        
        getting the length of the string:
            
            string=abcd
            echo ${#string}
            
        getting the index of the assigned string:
            a='hello cuhksz'
            echo `expr index "$a" lo` # print out 3

Calculation
    

Tuple
    
    tuple=(0 1 2 3 4 5)
    
    echo ${#tuple[@]} #length of the tuple
    
    echo ${tuple[n]} # print the element at specific location
    
    let a=${#tuple[@]}-1
    for i in `seq 0 $a` # use the element one by one
        do
            echo ${tuple[$i]}
        done
        
    
    
If Else 
    
    Using if clause:
        
        
    
    
For Loop

    Passing variable: 
        for file in $(ls)
            do
                echo $file #print all the variable return from ls
            done
        
        for i in `seq 1 100`
            do
	            echo $i # print all variable form 1 to 100
            done
    
While Loop