
# Function id

The following function
``` single
fun id x = x
fun f p = (id p) * p
f 4 
```

Solution

``` shel
========= Starting print the program =======
fun id x = x
fun f p = (id p) * p
f 4
============= End of program ===============

what is the expr x
what is the expr (id p) * p
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─f
└─4

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─@
      ├─id
      └─p
    └─p
└─4

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─@
      ├─x
      └─p
    └─p
└─4

============== Reduce tree ==================
@
├─@
  ├─*
  └─@
    ├─@
      ├─x
      └─p
    └─p
└─4

=========== Replace Argument ===============
@
├─*
└─@
  ├─4
  └─4

=========== And Reduce tree ================
16

============== Final Result =================
16
```