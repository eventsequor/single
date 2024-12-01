
# Function fourtimes callback

The following function
``` single
fun fourtimes x = var y = x * x in y + y
fourtimes fourtimes 2
```

Solution

``` shel
========= Starting print the program =======
fun fourtimes x = var y = x * x in y + y
fourtimes fourtimes 2
============= End of program ===============

what is the expr var y = x * x in y + y
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─fourtimes
└─@
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
└─@
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
└─@
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
└─@
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
└─8

=========== Replace Argument ===============
@
├─+
└─@
  ├─@
    ├─*
    └─@
      ├─8
      └─8
  └─@
    ├─*
    └─@
      ├─8
      └─8

=========== And Reduce tree ================
128

============== Final Result =================
128
```