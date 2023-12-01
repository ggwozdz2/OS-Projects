# MINIX Payment System

Enable MINIX processes to have currency and perform mutual transfers.

## New System Call

Add a system call PM_TRANSFER_MONEY and a library function `int transfermoney(pid_t recipient, int amount)` declared in unistd.h. Constants INIT_BALANCE = 100 and MAX_BALANCE = 1000 should be defined in minix/config.h.

The function transfers `amount` currency units from the calling process to the process with identifier `recipient`. On success, it returns the calling process's account balance post-transfer.

In case of failure, `transfermoney` returns -1 and sets errno:

- ESRCH if `recipient` isn't the identifier of the running process.
- EPERM if `recipient` is a descendant or ancestor of the calling process.
- EINVAL for negative `amount`, insufficient funds, or exceeding MAX_BALANCE.

The function uses the new system call `PM_TRANSFER_MONEY` in the `PM` server.

### Definitions:

```c
#define INIT_BALANCE 100
#define MAX_BALANCE 1000

int transfermoney(pid_t recipient, int amount);
```
