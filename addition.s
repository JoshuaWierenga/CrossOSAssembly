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

.text
main:
    // disable stdout buffer so that printf always writes to the screen
    sub rsp, 0x8
    mov rdi, stdout
    mov rsi, 0x0
    call setbuf
    add rsp, 0x8

    // allocate memory for 2 * 64 bit integers
    sub rsp, 0x8
    mov rdi, 0x16
    call malloc
    add rsp, 0x8

    // backup r12 and store pointer to allocated memory in it
    push r12
    mov r12, rax
        
    // request user input
    lea rdi, scanfRequest
    call printf
        
    // get 64 bit integer from stdin
    lea rdi, scanfInt
    mov rsi, r12
    call scanf

    // request user input
    lea rdi, scanfRequest
    call printf
    
    // recover memory pointer and move to second integer
    mov rsi, r12
    add rsi, 0x8

    // get 64 bit integer from stdin
    lea rdi, scanfInt
    call scanf

    // add 64 bit integers
    mov rsi, QWORD PTR [r12]
    add rsi, QWORD PTR [r12 + 0x8]
    
    // print addition result
    lea rdi, message
    call printf

    // free allocated memory
    mov rdi, r12
    call free

    // restore original r12
    pop r12
    ret
