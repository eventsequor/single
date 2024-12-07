# ======== Single ========

# Content
- [======== Single ========](#-single-)
- [Content](#content)
  - [Homework](#homework)
    - [Task 1](#task-1)
    - [Task 2](#task-2)
    - [Task 3](#task-3)
    - [Task 4](#task-4)
  - [What is Single?](#what-is-single)
  - [How to execute a program?](#how-to-execute-a-program)
  - [Syntax](#syntax)
  - [Program examples](#program-examples)


## Homework
### Task 1
 The step 0 in the implementation of template instantiation is to build the graph to represent the program. The graph consists of a tree describing the structure of the program with pointers referencing a same node (to avoid repeated evaluation). The graph is composed of two types of nodes (in its simplest representation)

  1. leaf nodes: representing constants (numbers) or variables 
  2. @ nodes: representing function applications

The following tree represent the next code, and also represent the implementation that we did to solve the requeriment.

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
Reduce the expression (a.k.a evaluate). For built-in primitives you have to evaluate them, for supercombinators replace their definition into the tree.

The first reduced tree
``` shell
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
Replace the variables to the right of the tree witht the defined variable 4
``` shell
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─@
  ├─*
  └─@
    ├─4
    └─4
```
Evaluates the first expression.
``` shell
@
├─@
  ├─*
  └─@
    ├─x
    └─x
└─16
```
Replace the new value in the next variables available in the tree.
``` shell
@
├─*
└─@
  ├─16
  └─16
```

### Task 4
Update the expression with the result of the evaluation. 

Note that not all programs need to be reducible (for example if the evaluation is not complete as variables are not known; the reduction of the expression x + x is itself if a value for x is unknown)

Final evaluation, solves the last operation with the values.

``` shell
256
```

## What is Single?
Single is a functional programming language that can only operate simple programs with numbers and variables.

Single is built using Mozart programming language, designed to focus on simplicity, clarity, and functional programming paradigms. It provides an intuitive syntax for working with high-level abstractions, making it ideal for programmers interested in functional programming concepts.

Template instantiation was used as the method for executing functional programs by systematically evaluating expressions. The process represents expressions as graphs and reduces them by replacing reducible parts with their evaluated values. The evaluation continues until the program reaches its normal form (i.e., when no more reducible expressions exist).

**Graph-Based Evaluation:**

The execution of programs involves building a graph of function calls and systematically reducing it step by step.
This allows the sharing of computations, preventing redundant evaluations and improving efficiency.

In this case the graph is shown as:
```
@
├─square
└─@
  ├─square
  └─4
```

Where `├─` represents a left node and `└─` a right node, this symbols where chosen for simplicity when printing the tree. This way the graph above is also represented as:
```
        @
       / \
  square  @
         / \
    square  4
```

Every program file is denoted with `.sl` to indicate the use of single programming language.

## How to execute a program?

Please before to run any program please compile each *.oz file, you can do that using the files compile.bat or compile.sh

Programs can be executed through different ways.

Main.oz file includes the chance of testing.


In [programs](programs/) folder each of the programs has its own test file that can be executed. Each should be compiled with

```
ozc -c programs/sum_n/SumNTest.oz
```
```
ozengine SumNTest.ozf
```

Or by entering directly to the folder with the program, for example for sum_n.

```
cd .\programs\sum_n\
```

```
ozc -c SumNTest.oz

ozengine SumNTest.ozf
```

## Syntax


- `fun` keyword is used to define a function.
```
fun function_name ...
```

- A function is invoked by writing its name followed by its arguments, separated by spaces.

```
fun function_name param1 param2 ... paramN ...
```

- All functions are designed to solve operations such as: `+, -, *, /, %`

```
fun sum x = x + x
```


- Some programs use `var` for local variable.

- The use of ` var... in ... ` is also to declare variables locally.


- Function calls follow parenthesis order of evaluation.
```
sum_n 1 (sum_n 1 1 1 2) 3 2
```

- Variables and operators should always be separated by a space.

## Program examples
You have to be in the root folder of the project to run all examples, however you can see each example executed in its Readme.md file through its link

- [square](programs/square/README.md)
  
  compile ``ozc -c programs/square/SquareTest.oz``

  execute ``ozengine SquareTest.ozf``

- [arithmetic](programs/arithmetic/README.md)

  compile  ``ozc -c programs/arithmetic/ArithmeticTest.oz``

  execute ``ozengine ArithmeticTest.ozf ``

- [div](programs/div/README.md)
  
  compile ``ozc -c programs/div/DivTest.oz``

  execute ``ozengine DivTest.ozf``

- [fourtimes](programs/fourtimes/README.md)

  compile ``ozc -c programs/fourtimes/FourtimesTest.oz``

  execute ``ozengine FourtimesTest.ozf``

- [fourtimes callback](programs/fourtimes_callback/README.md)

  compile ``ozc -c programs/fourtimes_callback/FourtimesCallbackTest.oz``

  execute ``ozengine FourtimesCallbackTest.ozf``

- [id](programs/id/README.md)
  
  compile  ``ozc -c programs/id/IdTest.oz``

  execute `` ozengine IdTest.ozf``

- [sqr](programs/sqr/README.md)

  compile ``ozc -c programs/sqr/SqrTest.oz``

  execute ``ozengine IdTest.ozf ``

- [square callback](programs/square_callback/README.md)

  compile ``ozc -c programs/square_callback/SquareCallbackTest.oz``

  execute ``ozengine SquareCallbackTest.ozf``

- [sum n](programs/sum_n/README.md)

  compile ``ozc -c programs/sum_n/SumNTest.oz``

  execute ``ozengine SumNTest.ozf ``

- [sum n callback](programs/sum_n_callback/README.md)

  compile ``ozc -c programs/sum_n_callback/SumNCallbackTest.oz``

  execute ``ozengine SumNCallbackTest.ozf ``

- [sum sub](programs/sum_sub/README.md)

  compile ``ozc -c programs/sum_sub/SumSubTest.oz``

  execute ``ozengine SumSubTest.ozf ``

- [twice](programs/twice/README.md)

  compile ``ozc -c programs/twice/TwiceTest.oz``

  execute ``ozengine TwiceTest.ozf ``

- [twice callback](programs/twice_callback/README.md)

  compile ``ozc -c programs/twice_callback/TwiceCallbackTest.oz``

  execute ``ozengine TwiceCallbackTest.ozf``

- [var use](programs/var_use/README.md)

  compile ``ozc -c programs/var_use/VarUseTest.oz``

  execute ``ozengine VarUseTest.ozf``