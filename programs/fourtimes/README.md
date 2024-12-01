
# Function fourtimes

The following function
``` single
fun fourtimes x = var y = x * x in y + y
fourtimes 2
```

Solution

``` shel
========= Starting print the program =======
fun fourtimes x = var y = x * x in y + y
fourtimes 2
============= End of program ===============

what is the expr var y = x * x in y + y
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─fourtimes
└─2

===== Replace names func by its tree ========
@
├─@
  ├─+
  └─@
    ├─@
      ├─*
      └─@
        ├─x
        └─x
    └─@
      ├─*
      └─@
        ├─x
        └─x
└─2

============== Reduce tree ==================
@
├─@
  ├─+
  └─@
    ├─@
      ├─*
      └─@
        ├─x
        └─x
    └─@
      ├─*
      └─@
        ├─x
        └─x
└─2

=========== Replace Argument ===============
@
├─+
└─@
  ├─@
    ├─*
    └─@
      ├─2
      └─2
  └─@
    ├─*
    └─@
      ├─2
      └─2

=========== And Reduce tree ================
8

============== Final Result =================
8
```