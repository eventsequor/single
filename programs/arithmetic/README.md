
# Function arithmetic

The following function
``` single
fun arithmetic x y = ((x + y) / (x - y)) * 2
arithmetic (arithmetic 5 6) (arithmetic 2 11)
```

Solution

``` shel
========= Starting print the program =======
fun arithmetic x y = ((x + y) / (x - y)) * 2
arithmetic (arithmetic 5 6) (arithmetic 2 11)
============= End of program ===============

what is the expr ((x + y) / (x - y)) * 2
===== Starting callbacks resolution ========

New CallBack

================ RootTree ==================
@
├─arithmetic
└─arithmetic 5 6
               └─arithmetic 2 11

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─@
      ├─/
      └─@
        ├─@
          ├─+
          └─@
            ├─x
            └─y
        └─@
          ├─-
          └─@
            ├─x
            └─y
    └─2
└─@
  ├─arithmetic
  └─5
    └─6
      └─@
        ├─arithmetic
        └─2
          └─11

===== Replace names func by its tree ========
@
├─@
  ├─*
  └─@
    ├─@
      ├─/
      └─@
        ├─@
          ├─+
          └─@
            ├─x
            └─y
        └─@
          ├─-
          └─@
            ├─x
            └─y
    └─2
└─@
  ├─@
    ├─*
    └─@
      ├─@
        ├─/
        └─@
          ├─@
            ├─+
            └─@
              ├─x
              └─y
          └─@
            ├─-
            └─@
              ├─x
              └─y
      └─2
  └─5
    └─6
      └─@
        ├─@
          ├─*
          └─@
            ├─@
              ├─/
              └─@
                ├─@
                  ├─+
                  └─@
                    ├─x
                    └─y
                └─@
                  ├─-
                  └─@
                    ├─x
                    └─y
            └─2
        └─2
          └─11

============== Reduce tree ==================
@
├─@
  ├─*
  └─@
    ├─@
      ├─/
      └─@
        ├─@
          ├─+
          └─@
            ├─x
            └─y
        └─@
          ├─-
          └─@
            ├─x
            └─y
    └─2
└─@
  ├─@
    ├─*
    └─@
      ├─@
        ├─/
        └─@
          ├─@
            ├─+
            └─@
              ├─x
              └─y
          └─@
            ├─-
            └─@
              ├─x
              └─y
      └─2
  └─5
    └─6
      └─@
        ├─@
          ├─*
          └─@
            ├─@
              ├─/
              └─@
                ├─@
                  ├─+
                  └─@
                    ├─x
                    └─y
                └─@
                  ├─-
                  └─@
                    ├─x
                    └─y
            └─2
        └─2
          └─11

=========== Replace Argument ===============
@
├─@
  ├─*
  └─@
    ├─@
      ├─/
      └─@
        ├─@
          ├─+
          └─@
            ├─x
            └─y
        └─@
          ├─-
          └─@
            ├─x
            └─y
    └─2
└─@
  ├─*
  └─@
    ├─@
      ├─/
      └─@
        ├─@
          ├─+
          └─@
            ├─5
            └─6
        └─@
          ├─-
          └─@
            ├─5
            └─6
    └─2
      └─@
        ├─*
        └─@
          ├─@
            ├─/
            └─@
              ├─@
                ├─+
                └─@
                  ├─2
                  └─11
              └─@
                ├─-
                └─@
                  ├─2
                  └─11
          └─2

=========== And Reduce tree ================
@
├─@
  ├─*
  └─@
    ├─@
      ├─/
      └─@
        ├─@
          ├─+
          └─@
            ├─x
            └─y
        └─@
          ├─-
          └─@
            ├─x
            └─y
    └─2
└─~22
    └─~2.8888

=========== Replace Argument ===============
@
├─*
└─@
  ├─@
    ├─/
    └─@
      ├─@
        ├─+
        └─@
          ├─~22
          └─~2.8888
      └─@
        ├─-
        └─@
          ├─~22
          └─~2.8888
  └─2

=========== And Reduce tree ================
2.6046

============== Final Result =================
2.6046
```