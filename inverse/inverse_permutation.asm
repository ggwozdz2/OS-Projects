global inverse_permutation

inverse_permutation:
        cmp     edi, 0x0    ; check if number of elements is not 0
        je      any_error     
        test    edi, edi    ; check if edi does not exceed 32-bit positive int (it would be too big)
        js      any_error     
        mov     edx, edi    ; loop iterator
        mov     rcx, rsi    ; pointer to the array

proper_numbers_loop:        ; loop checking if all numbers are positive and smaller than array size
        mov     eax, [rcx]
        cmp     eax, edi    ; check if numbers are less than array size
        jge     any_error     
        test    eax, eax    ; check if values are not negative
        js      any_error     
        sub     edx, 0x1    ; test if rbx is already 1, which means end of the loop
        je      data_restore
        add     rcx, 0x4 
        jmp     proper_numbers_loop

data_restore:              ; restoring values
        mov     edx, edi 
        mov     rcx, rsi
        
permutation_loop:                               ; checking if array is a permutation (no duplicates)
        mov     eax, [rcx]
        test    eax, eax                        ; test if index was visited
        js      permutation_loop_continue       ; visited, go to next element
        mov     r8, rcx                         ; starting address
        mov     r9, rcx                         ; address of current element
        jmp     check_if_permutation            ; started with new element, checking if array is a permutation (no duplicates)

permutation_loop_continue:                      ; body of loop above used to increment specified registers (size counter and index in array) 
        sub     edx, 0x1
        je      make_inverse                    ; end of this loop, data is correct, start making inverse
        add     rcx, 0x4
        jmp     permutation_loop

check_if_permutation:                           ; mark all array elements as 'visited', go through permutation cycle, mark other elements
                                                ; in this cycle; if we encounter marked element different than initial, it is duplicated
        mov     eax, [r9]                       
        test    eax, eax                        ; check if it was already visited, which means no permutation
        js      error_duplicate
        xor     dword [r9], 0xffffffff          ; get 'the opposite' number from given
        lea     r9, [rsi + 4*rax]
        cmp     r9, r8                          ; check if we moved to initial address
        je      permutation_loop_continue          
        jmp     check_if_permutation            ; go to another element in this cycle

error_duplicate:                                ; encountered duplicate in permutation
        mov     edx, edi
        mov     rcx, rsi

fix_numbers_loop:                               ; used to 'unxor' values of init array, called only in case of duplicate error
        mov     eax, [rcx]
        test    eax, eax
        js      unxor_number

fix_loop_continue:                              ; body of the loop above
        sub     edx, 0x1
        je      any_error                       ; after fixing array, we have to return false
        add     rcx, 0x4
        jmp     fix_numbers_loop

unxor_number:                                   ; remove effects of xoring to mark as visited
        xor     dword [rcx], 0xffffffff
        jmp     fix_loop_continue

any_error:                                      ; making function return false
        xor     rax, rax
        jmp     end 

make_inverse:                                   ; start of actual permutation inverse
        mov     edx, 0x0
        mov     rcx, rsi

inverse_loop:                                   ; loop goes through each array element, if it is unvisted, start a cycle
        mov     eax, [rcx]
        mov     r9d, edx
        test    eax, eax                        ; check if visited
        js      set_inverse                     ; not visited, start setting proper inverse array values

inverse_loop_continue:                          ; body of the loop above
        add     rcx, 0x4                        
        add     edx, 0x1
        cmp     edx, edi
        je      no_errors
        jmp     inverse_loop

set_inverse:
        test    eax, eax                        ; test if number is not negative, which means already fixed
        jns     inverse_loop_continue 
        xor     eax, 0xffffffff
        mov     r8d, [rsi + 4 * rax]            ; save what is next element (current p[i]) 
        mov     dword [rsi + 4 * rax], r9d      ; change current array element
        mov     r9d, eax                        ; set 'current_array' index
        mov     eax, r8d                        ; set 'where to go' now, equivalent to previous value of p[i]
        jmp     set_inverse

no_errors:
        mov rax, 0x1
end:
        ret
