
# Function sum n

The following function
``` single
fun sum_n x y z n = (x + y + z) * n
sum_n 1 4 3 2
```

Solution

``` shel
========= Starting print the program =======
fun sum_n x y z n = (x + y + z) * n
sum_n 1 4 3 2
============= End of program ===============

what is the expr (x + y + z) * n
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─sum_n
└─1
  └─4
    └─3
      └─2

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─@
      ├─+
      └─@
        ├─x
        └─@
          ├─+
          └─@
            ├─y
            └─z
    └─n
└─1
  └─4
    └─3
      └─2

============== Reduce tree ==================
@
├─@
  ├─*
  └─@
    ├─@
      ├─+
      └─@
        ├─x
        └─@
          ├─+
          └─@
            ├─y
            └─z
    └─n
└─1
  └─4
    └─3
      └─2

=========== Replace Argument ===============
@
├─*
└─@
  ├─@
    ├─+
    └─@
      ├─1
      └─@
        ├─+
        └─@
          ├─4
          └─3
  └─2

=========== And Reduce tree ================
16

============== Final Result =================
16
```