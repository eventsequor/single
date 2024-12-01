
# Function sqr

The following function
``` single
fun sqr x = (x + 1) * (x - 1)
sqr 4
```

Solution

``` shel
========= Starting print the program =======
fun sqr x = (x + 1) * (x - 1)
sqr 4
============= End of program ===============

what is the expr (x + 1) * (x - 1)
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─sqr
└─4

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─@
      ├─+
      └─@
        ├─x
        └─1
    └─@
      ├─-
      └─@
        ├─x
        └─1
└─4

============== Reduce tree ==================
@
├─@
  ├─*
  └─@
    ├─@
      ├─+
      └─@
        ├─x
        └─1
    └─@
      ├─-
      └─@
        ├─x
        └─1
└─4

=========== Replace Argument ===============
@
├─*
└─@
  ├─@
    ├─+
    └─@
      ├─4
      └─1
  └─@
    ├─-
    └─@
      ├─4
      └─1

=========== And Reduce tree ================
15

============== Final Result =================
15
```