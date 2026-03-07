section .text
    global _start

_start:
    mov rcx, 5

loop:
    dec rcx
    cmp rcx, 0
    jne loop

    mov rax, 60
    xor rdi, rdi
    syscall