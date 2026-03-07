section .text
    global _start

_start:
    mov al, 5
    mov bl, 7
    add al, bl

    mov rax, 60
    xor rdi, rdi
    syscall