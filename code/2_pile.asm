section .text
    global _start

_start:
    mov rax, 10
    mov rbx, 12
    mov rcx, 26

    push rax
    push rbx
    push rcx

    pop rdx ; rdx = rcx = 26
    pop rsi ; rsi = rbx = 12
    pop rdi ; rdi = rax = 10

    jmp exit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall