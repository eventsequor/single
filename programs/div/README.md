
# Function div

The following function
``` single
fun div a b = b / a
div 5 10
```

Solution

``` shel
========= Starting print the program =======
fun div a b = b / a
div 5 10
============= End of program ===============

what is the expr b / a
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─div
└─5
  └─10

===== Replace names func by its tree ========
@
├─@
  ├─/
  └─@
    ├─b
    └─a
└─5
  └─10

============== Reduce tree ==================
@
├─@
  ├─/
  └─@
    ├─b
    └─a
└─5
  └─10

=========== Replace Argument ===============
@
├─/
└─@
  ├─10
  └─5

=========== And Reduce tree ================
2

============== Final Result =================
2
```