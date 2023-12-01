# Inverse 

## Overview

Implement a function in assembly language that can be called from the C language:

```c
bool inverse_permutation(size_t n, int *p);
```

## Description

The function takes a pointer p to a non-empty array of integers and the size of this array n as arguments. If the array pointed to by p contains a permutation of numbers from 0 to n-1, the function reverses this permutation in place and returns true. Otherwise, it returns false, and the content of the array pointed to by p remains unchanged.

The function is designed to detect obviously incorrect values of n. The pointer p is assumed to be valid.

## Files

Solution: `inverse_permutation.asm`.

Sample usage (provided by authors): `inverse_permutation_example.c`.