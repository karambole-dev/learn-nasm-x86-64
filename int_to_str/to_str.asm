section .data
    digit dd 869
    digit_ascii_temp db 0

section .text
    global _start

_start:
    jmp while_digit_not_empty

while_digit_not_empty:
    cmp byte [digit], 0
    jbe init_loop

    mov eax, [digit]
    mov edx, 0
    mov ebx, 10
    div ebx ; rax=quotient / rdx=rest

    mov [digit], rax

    add rdx, 48
    mov [digit_ascii_temp], dl

    movzx rcx, byte [digit_ascii_temp]
    push rcx

    jmp while_digit_not_empty

init_loop:
    mov rbx, 4

display_digit:
    dec rbx
    cmp rbx, 0
    je exit

    pop rcx
    mov [digit_ascii_temp], cl
    mov rax, 1
    mov rdi, 1
    mov rsi, digit_ascii_temp
    mov rdx, 1
    syscall

    jmp display_digit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall