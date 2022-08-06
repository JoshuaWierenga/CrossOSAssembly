_CRT_INIT proto
ExitProcess proto

malloc proto
free proto
scanf proto
printf proto

includelib msvcrt.lib
includelib legacy_stdio_definitions.lib

.data
    message db "sum is %lld", 13, 10, 0
    scanfInt db "%lld", 0
    scanfRequest db "enter an integer: ", 0

.code
main proc
    ;; setup c runtime
    sub rsp, 40h
    call _CRT_INIT
    add rsp, 40h

    ;; allocate memory for 2 * 64 bit integers
    sub rsp, 40h
    mov rcx, 16h 
    call malloc
    add rsp, 40h

    ;; backup r12 and store pointer to allocated memory in it
    push r12
    mov r12, rax
    
    ;; request user input
    sub rsp, 40h
    lea rcx, scanfRequest
    call printf
    add rsp, 40h

    ;; get 64 bit integer from stdin
    sub rsp, 40h
    lea rcx, scanfInt
    mov rdx, r12
    call scanf
    add rsp, 40h

    ;; request user input
    sub rsp, 40h
    lea rcx, scanfRequest
    call printf
    add rsp, 40h

    ;; recover memory pointer and move to second integer
    mov rdx, r12
    add rdx, 8h

    ;; get 64 bit integer from stdin
    sub rsp, 40h
    lea rcx, scanfInt
    call scanf
    add rsp, 40h

    ;; add 64 bit integers
    mov rdx, QWORD PTR [r12]
    add rdx, QWORD PTR [r12 + 8h]
    
    ;; print addition result
    sub rsp, 40h
    lea rcx, message
    call printf
    add rsp, 40h

    ;; free allocated memory
    sub rsp, 40h
    mov rcx, r12
    call free
    add rsp, 40h

    ;; restore original r12
    pop r12

    ;; notify windows that the proccess is over, preferred over just using ret
    sub rsp, 40h
    xor rcx, rcx
    call ExitProcess
main endp

end
