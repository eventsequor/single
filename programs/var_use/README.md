
# Function var use

The following function
``` single
fun var_use x = var y = x * x in y + y
var_use 3
```

Solution

``` shell
========= Starting print the program =======
fun var_use x = var y = x * x in y + y
var_use 3
============= End of program ===============

what is the expr var y = x * x in y + y
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─var_use
└─3

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
└─3

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
└─3

=========== Replace Argument ===============
@
├─+
└─@
  ├─@
    ├─*
    └─@
      ├─3
      └─3
  └─@
    ├─*
    └─@
      ├─3
      └─3

=========== And Reduce tree ================
18

============== Final Result =================
18
```