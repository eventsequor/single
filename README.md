# ======== Single ========

# Content
- [======== Single ========](#-single-)
- [Content](#content)
  - [Homework](#homework)
    - [Task 1](#task-1)
    - [Task 2](#task-2)
    - [Task 3](#task-3)
    - [Task 4](#task-4)
  - [How to execute a program?](#how-to-execute-a-program)
  - [What is single?](#what-is-single)
  - [Programs examples](#programs-examples)
  - [Syntax](#syntax)



## Homework
### Task 1
 The step 0 in the implementation of template instantiation is to build the graph to represent the program. The graph consists of a tree describing the structure of the program with pointers referencing a same node (to avoid repeated evaluation). The graph is composed of two types of nodes (in its simplest representation)

  1. leaf nodes: representing constants (numbers) or variables 
  2. @ nodes: representing function applications

The follwing tree represent the next code, and also represent the implementation that we did to solve the requeriment

Function
``` single
fun square x = x * x
square square 4
```

It's root tree
``` shell
@
├─square
└─@
  ├─square
  └─4
```

### Task 2
Find the next expression to reduce. The expression to reduce must always be the outermost expression in the tree.

1. Follow the left branch of the application nodes, starting at the root, until you get to a supercombinator or built-in primitive.
   
2. Check how many arguments the supercombinator or primitive takes and go back up that number of application nodes; you have now found the root of the outermost function application.
   
Function

``` single
fun square x = x * x
square square 4
```

It's root tree
``` shell
@
├─square
└─@
  ├─square
  └─4
```

It's reduce tree
```shell
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─@
  ├─@
    ├─*
    └─@
      ├─x
      └─x
  └─4
```
### Task 3
Reduce the expression (a.k.a evaluate). For built-in primitives you have to
evaluate them, for supercombinators replace their de nition into the tree

### Task 4
Update the expression with the result of the evaluation.
  Note that not all programs need to be reducible (for example if the evaluation is not
  complete as variables are not known; the reduction of the expression x + x is itself if a
  value for x is unknown)

## How to execute a program?



## What is single?
Single is a functional language programing that only can operate simple operations with numbers

## Programs examples
- [square](programs/square/README.md)
- [fourtimes](programs/fourtimes/README.md)
- 3
## Syntax
- Functions are defined by "fun"
- Variables are defined by "var"
