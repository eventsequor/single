
# Function square

The following 
``` single
fun square x = x * x
square 4
```

``` shel
========= Starting print the program =======
fun square x = x * x
square 4
============= End of program ===============

what is the expr x * x
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─square
└─4

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─4

============== Reduce tree ==================
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─4

=========== Replace Argument ===============
@
├─*
└─@
  ├─4
  └─4

=========== And Reduce tree ================
16

============== Final Result =================
16
```