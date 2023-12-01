# Core - Distributed Stack Machine Simulator

## Description

Implement an x86_64 assembly simulator for a distributed stack machine. The machine consists of N cores, numbered from 0 to N − 1, where N is a constant determined during the compilation of the simulator. The simulator will be used from the C language in such a way that N threads will be run, and in each thread, the following function will be called:

```c
uint64_t core(uint64_t n, char const *p);
```

The parameter n contains the core number, and the parameter p is a pointer to an ASCIIZ string defining the computation the core should perform. The computation consists of operations executed on a stack, which is initially empty. Interpret the characters of the string as follows:

    + – pop two values from the stack, calculate their sum, and push the result onto the stack;
    * – same, but product of numbers
    - – negate arithmetically the value at the top of the stack;
    0 to 9 – push the corresponding value (0 to 9) onto the stack;
    n – push the core number onto the stack;
    B – pop a value from the stack, if the value at the top of the stack is non-zero, treat the popped value as a two's complement number, and shift by that many operations;
    C – pop a value from the stack and discard it;
    D – duplicate the value at the top of the stack;
    E – swap the top two values on the stack;
    G – push the value obtained from calling (implemented elsewhere in C) the function uint64_t get_value(uint64_t n) onto the stack;
    P – pop a value from the stack (let's denote it as w) and call (implemented elsewhere in C) the function void put_value(uint64_t n, uint64_t w);
    S – synchronize cores, pop a value from the stack, treat it as the core number m, wait for operation S of core m with the popped core number n from the stack, and swap values on the tops of the stacks of cores m and n.

After the core completes the computation, the result, i.e., the result of the core function, is the value at the top of the stack. All operations are performed on 64-bit numbers modulo 2 to the power of 64.

## Files

Solution: `core.asm`

Sample usage (provided by authors): `example.c`
