###Posix Threads Programming
   
To do the posix threads programming, you need to first understand a life cycle of a thread.

* [thread life cycle in JAVA](https://www.javatpoint.com/life-cycle-of-a-thread)

* [posix thread life cycle](https://www.usna.edu/Users/cs/aviv/classes/ic221/s16/lec/28/lec.html)

* [pthreads library](https://docs.oracle.com/cd/E18752_01/html/816-5137/tlib-1.html)

Samples usage are in the document. You can take a look a look at the [pthreads library](https://docs.oracle.com/cd/E18752_01/html/816-5137/tlib-1.html)
and find the usage of all different functions in the document.

* Extended reading: https://computing.llnl.gov/tutorials/pthreads/
        
    This one introduces some other basic knowledge about thread. Lots of examples included. 


-------
### Lock

* [mutex lock](https://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html) introduces some of the basic locks used in pthread programming

* [optimistic and pessimistic locking](https://enterprisecraftsmanship.com/posts/optimistic-locking-automatic-retry/) introduces one of the basic concept about locks

* Extended reading: https://zhuanlan.zhihu.com/p/53910908
   
     This article introduces some other kinds of locks like spin-lock, condition-lock, recursive-lock...
     you can find further examples on the internet.