
# Function square callback

The following 
``` single
fun square x = x * x
square square 4
```

Solution

``` shell
========= Starting print the program =======
fun square x = x * x
square square 4
============= End of program ===============

what is the expr x * x
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─square
└─@
  ├─square
  └─4

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─@
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
└─@
  ├─@
    ├─*
    └─@
      ├─x
      └─x
  └─4

=========== Replace Argument ===============
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─@
  ├─*
  └─@
    ├─4
    └─4

=========== And Reduce tree ================
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─16

=========== Replace Argument ===============
@
├─*
└─@
  ├─16
  └─16

=========== And Reduce tree ================
256

============== Final Result =================
256
```