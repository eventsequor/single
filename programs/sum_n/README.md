
# Function twice

The following function
``` single
fun sum_n x y z n = (x + y + z) * n
sum_n 1 (sum_n 1 1 1 2) 3 2
```

Solution

``` shel
========= Starting print the program =======
fun sum_n x y z n = (x + y + z) * n
sum_n 1 (sum_n 1 1 1 2) 3 2
============= End of program ===============

what is the expr (x + y + z) * n
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─sum_n
└─1
  └─sum_n 1 1 1 2
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
  └─@
    ├─sum_n
    └─1
      └─1
        └─1
          └─2
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
  └─@
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
      └─1
        └─1
          └─2
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
  └─@
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
      └─1
        └─1
          └─2
            └─3
              └─2

=========== Replace Argument ===============
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
  └─@
    ├─*
    └─@
      ├─@
        ├─+
        └─@
          ├─1
          └─@
            ├─+
            └─@
              ├─1
              └─1
      └─2
        └─3
          └─2

=========== And Reduce tree ================
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
  └─6
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
          ├─6
          └─3
  └─2

=========== And Reduce tree ================
20

============== Final Result =================
20
```