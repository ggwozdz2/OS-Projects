# Wait

## Solution Specification

Implement new system calls in the PM server to facilitate synchronization between related processes.

The implemented system calls are encapsulated in library functions:

```c
void wait_for_parent(void);
void wait_for_child(void);
void wait_for_sibling(void);
```

These functions should be declared in the `unistd.h` file.

    wait_for_parent() suspends the process until its parent process calls wait_for_child().
    wait_for_child() suspends the process until its child process calls wait_for_parent().
    wait_for_sibling() suspends the process until its sibling process, i.e., another child of the same parent process, calls wait_for_sibling().

These functions should be reusable, allowing multiple synchronizations of processes.
