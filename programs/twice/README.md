
# Function twice

The following function
``` single
fun twice x = x + x
twice twice 5
```

Solution

``` shel
========= Starting print the program =======
fun twice x = x + x
twice 5
============= End of program ===============

what is the expr x + x
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─twice
└─5

===== Replace names func by its tree ========
@
├─@
  ├─+
  └─@
    ├─x
    └─x
└─5

============== Reduce tree ==================
@
├─@
  ├─+
  └─@
    ├─x
    └─x
└─5

=========== Replace Argument ===============
@
├─+
└─@
  ├─5
  └─5

=========== And Reduce tree ================
10

============== Final Result =================
10
```