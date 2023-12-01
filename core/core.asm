global core
extern get_value
extern put_value

section .data

which_reads: times N dq N         ; array used to synchronize reading by 2 cores

section .bss

current_value: resq N           ; array storing current value of each core (if needed)

section .text

core:
        ; core function enables operations +, -, *, B, C, D, E, G, P, n and S
        ; rcx - stores the address of the current character in the given string of operations
        ; rbp - stores initial value of rsp
        ; rax, rbx, rd8 are used for different purposes in different functions

        mov     rcx, rsi
        push    rbp
        mov     rbp, rsp        ; saving initial rsp value

loop:
        movzx   eax, byte [rcx] ; reading current character

test_end:                       ; test if end of the string with instructions
        test    eax, eax
        jnz     test_add_and_multiply
end:
        mov     rax, [rsp]
        mov     rsp, rbp        ; restore stack
        pop     rbp
        ret

test_add_and_multiply:
        cmp     al, '+'
        je      add
        jl      multiply        ; it means it had to be '*'

test_digit_and_negation:
        cmp     al, '0'
        jl      negation        ; it means it had to be '-'
        cmp     al, '9'
        jle     digit

test_B_and_C:
        cmp     al, 'C'
        je      operation_C
        jl      operation_B

test_D_and_E:
        cmp     al, 'E'
        je      operation_E
        jl      operation_D

test_G_and_P:
        cmp     al, 'P'
        je      operation_P
        jl      operation_G

test_n_and_S:
        cmp     al, 'n'
        je      operation_n

operation_S:
        lea     rsi, [rel current_value]
        lea     r8, [rel which_reads]
        pop     rax                             ; number of core which swaps get_value
        pop     rdx                             ; number to swap
        mov     [rsi + 8 * rdi], rdx            ; save current value on shared array 
        mov     [r8 + 8 * rdi], rax             ; mark for which current core waits
spinlock:
        mov     rdx, [r8 + 8 * rax]             ; check whether other core is ready to swap
        cmp     rdx, rdi                        
        jne     spinlock
critical_section:
        mov     rdx, [rsi + 8 * rax]            ; get the value of the other core
        push    rdx                             
        mov     QWORD [r8 + 8 * rax], N         ; making this value equal to N marks it as 'read' by the other process
spinlock_end:
        mov     rax, [r8 + 8 * rdi]
        cmp     rax, N
        jne     spinlock_end                    ; it means the other process still might not have read the current value
        jmp     loop_end

add: 
        pop     rax
        add     [rsp], rax
        jmp     loop_end

negation:
        neg     QWORD [rsp]
        jmp     loop_end

multiply:
        pop     rax
        pop     rdx
        imul    rax, rdx                        ; multiply both registers, result saved in rax
        push    rax
        jmp     loop_end

digit:
        sub     rax, '0'
        push    rax
        jmp     loop_end
        
operation_B:
        pop     rdx
        pop     rax
        push    rax                             ; double pop is faster than moving top of stack
        test    rax, rax
        jz      loop_end
        add     rcx, rdx                        ; if not zero, move in the char of operations
        jmp     loop_end

operation_C:
        pop     rax
        jmp     loop_end

operation_D:
        push    QWORD [rsp]                      ; duplication
        jmp     loop_end

operation_E:
        pop     rax                             ; taking numbers from stack and adding back in inversed order
        pop     rdx
        push    rax
        push    rdx
        jmp     loop_end

operation_n:
        push    rdi
        jmp     loop_end

operation_G:
        push    rcx                             ; saving all registers before call
        push    rdi
        push    rbx
        mov     rbx, rsp
        and     rsp, 0xFFFFFFFFFFFFFFF0
        call    get_value        
        mov     rsp, rbx
        pop     rbx                             ; restoring registers
        pop     rdi
        pop     rcx
        push    rax
        jmp     loop_end

operation_P:
        pop     rsi                              
        push    rcx                             ; saving all registers before call
        push    rdi
        push    rbx
        mov     rbx, rsp
        and     rsp, 0xFFFFFFFFFFFFFFF0
        call    put_value               
        mov     rsp, rbx                        ; restoring registers
        pop     rbx
        pop     rdi
        pop     rcx

loop_end:
        inc     rcx
        jmp     loop
