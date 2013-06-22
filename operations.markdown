YINlang Operations
==================

YIN operators are composed of 1 symbol or 3 letters.

All operators are infix style, though some may only take a single argument, in which case they may appear to be postfix.

Each operator accepts 1 to n arguments, with argument 3..n being repetitions of the operation on the resulting value of the previous two arguments.

The standard format is:

    x o y n

Where `x` is the *initial* argument, `o` is the *operator*, `y` is the *subordinate* argument and `n` are the *supplementary* arguments.

For example:

    2 + 3 4

Gives:

    9

There is no set upper limit to the number of possible arguments.

Known Operators
===============

Symbol Operators
----------------

- + : (nmbr) addition
- - : (nmbr) subtraction
- / : (nmbr) division
- * : (nmbr) multiplication
- ^ : (nmbr) exponentiation

Triune Operators
----------------

- nxt : (nmbr) next value
- sqr : (nmbr) square
- sqt : (nmbr) square root

### Planned Triunes

- prv : (nmbr) previous value
- log : (nmbr) logrithm
- min : (nmbr) smallest number
- max : (nmbr) largest number
- sum : (list) sum of (numr)s in list
- fib : (nmbr) returns x (list:nmbr) in fib sequence from given seed y..n

Planned Features
================

- Operator chaining : Results of previous operators are passed to the next as the initial argument.
- Additional types : (list) and (text) types.

