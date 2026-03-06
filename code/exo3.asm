section .data
    count_txt db "Count: "
    len_count_txt equ 7

section .text
    global _start

_start:
    mov rbx, 5

loop:
    dec rbx
    cmp rbx, 0
    je exit
    call display_count

    mov al, rbx
    add al, '0' ; convertie le chiffre en ascii
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel al]
    mov rdx, 1
    syscall

    jmp loop

display_count:
    mov rax, 1
    mov rdi, 1
    mov rsi, count_txt
    mov rdx, len_count_txt
    syscall
    ret

exit:
    mov rax, 60
    xor rdi, rdi
    syscall