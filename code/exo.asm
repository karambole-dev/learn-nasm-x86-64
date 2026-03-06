section .data
    msg db "Hello", 10
    len equ 6

section .text
    global _start

_start:
    mov rbx, 5

loop:
    dec rbx

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    cmp rbx, 0
    jne loop

    mov rax, 60
    xor rdi, rdi
    syscall