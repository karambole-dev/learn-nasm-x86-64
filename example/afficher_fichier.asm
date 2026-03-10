section .data
    filename db "toto.txt"
    fd dq 0

section .bss
    buffer resb 4096

section .text
    global _start

_start:
    mov rax, 2 ; open
    mov rdi, filename
    mov rsi, 0
    mov rdx, 0
    syscall

    mov [fd], rax

    mov rax, 0 ; read
    mov rdi, [fd]
    mov rsi, buffer
    mov rdx, 4096
    syscall
    mov r8, rax

    mov rax, 1 ; write
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r8
    syscall

    mov rax, 3 ; close
    mov rdi, [fd]
    syscall

    jmp exit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; nasm -f elf64 afficher_fichier.asm ; ld afficher_fichier.o -o afficher_fichier ; ./afficher_fichier