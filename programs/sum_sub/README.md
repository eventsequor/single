
# Function sum subtraction

The following function
``` single
fun sub x y = x - y
fun sum x y = x + y
sum (sub 8 4) (sub 10 5)
```

Solution

``` shel
========= Starting print the program =======
fun sub x y = x - y
fun sum x y = x + y
sum (sub 8 4) (sub 10 5)
============= End of program ===============

what is the expr x - y
what is the expr x + y
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─sum
└─sub 8 4
        └─sub 10 5

===== Replace names func by its tree ========
@
├─@
  ├─+
  └─@
    ├─x
    └─y
└─@
  ├─sub
  └─8
    └─4
      └─@
        ├─sub
        └─10
           └─5

===== Replace names func by its tree ========
@
├─@
  ├─+
  └─@
    ├─x
    └─y
└─@
  ├─@
    ├─-
    └─@
      ├─x
      └─y
  └─8
    └─4
      └─@
        ├─@
          ├─-
          └─@
            ├─x
            └─y
        └─10
           └─5

============== Reduce tree ==================
@
├─@
  ├─+
  └─@
    ├─x
    └─y
└─@
  ├─@
    ├─-
    └─@
      ├─x
      └─y
  └─8
    └─4
      └─@
        ├─@
          ├─-
          └─@
            ├─x
            └─y
        └─10
           └─5

=========== Replace Argument ===============
@
├─@
  ├─+
  └─@
    ├─x
    └─y
└─@
  ├─-
  └─@
    ├─8
    └─4
      └─@
        ├─-
        └─@
          ├─10
          └─5

=========== And Reduce tree ================
@
├─@
  ├─+
  └─@
    ├─x
    └─y
└─4
  └─5

=========== Replace Argument ===============
@
├─+
└─@
  ├─4
  └─5

=========== And Reduce tree ================
9

============== Final Result =================
9
```