.intel_syntax noprefix

.data
message:
    .asciz "sum is %lld\n"
    .globl	main
scanfInt:
    .asciz " %lld"
    .globl	main
scanfRequest:
    .asciz "enter an integer: "
    .globl	main
hi:
    .asciz "hi %s"
    .global	main

.text

get64bitinteger:
    // allocate memory for a c string: 1 optional minus sign/hyphen + 19 digits + new line + null terminator
    sub rsp, 0x8
    mov rdi, 22
    call malloc
    add rsp, 0x8

    // backup r13 and store pointer to allocated memory in it
    push r13
    mov r13, rax

    // use read to populate allocated memory with upto 21 ascii chars as described above
    mov rdi, 0x0
    mov rsi, rax
    mov rdx, 21
    call read

    // null terminate memory after last char to create c string
    mov WORD PTR [r13 + rax], 0x0

    // attempt to parse c string to a 64 bit integer, result is 0 if non integral chars are found, just like scanf
    mov rdi, r13
    call atoll

    // backup r14 and store parsed integer in it
    push r14
    mov r14, rax

    // free allocated memory
    mov rdi, r13
    call free

    // move parsed integer to return register and restore r13 and r14
    mov rax, r14
    pop r14
    pop r13

    ret

main:
    // disable stdout buffer so that printf always writes to the screen
    sub rsp, 0x8
    mov rdi, stdout
    mov rsi, 0x0
    call setbuf

    // request user input
    lea rdi, scanfRequest
    call printf

    // get 64 bit integer from stdin
    call get64bitinteger
    add rsp, 0x8

    // backup r12 and store entered 64 bit integer in it
    push r12
    mov r12, rax

    // request user input
    lea rdi, scanfRequest
    call printf

    // get 64 bit integer from stdin
    call get64bitinteger

    // add 64 bit integers
    mov rsi, rax
    add rsi, r12

    // print addition result
    lea rdi, message
    call printf

    // restore original r12
    pop r12

    ret
