
# Function twice callback

The following 
``` single
fun twice x = x + x
twice twice 5
```

Solution

``` shell
========= Starting print the program =======
fun twice x = x + x
twice twice 5
============= End of program ===============

what is the expr x + x
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─twice
└─@
  ├─twice
  └─5

===== Replace names func by its tree ========
@
├─@
  ├─+
  └─@
    ├─x
    └─x
└─@
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
└─@
  ├─@
    ├─+
    └─@
      ├─x
      └─x
  └─5

=========== Replace Argument ===============
@
├─@
  ├─+
  └─@
    ├─x
    └─x
└─@
  ├─+
  └─@
    ├─5
    └─5

=========== And Reduce tree ================
@
├─@
  ├─+
  └─@
    ├─x
    └─x
└─10

=========== Replace Argument ===============
@
├─+
└─@
  ├─10
  └─10

=========== And Reduce tree ================
20

============== Final Result =================
20
```