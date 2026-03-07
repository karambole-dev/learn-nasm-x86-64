%define NB_OCTETS_TO_READ 5

section .data
    filename db "output.txt", 0
    keys db 1

section .text
    global _start

_start:
    mov rax, 0 ; sys_read
    mov rdi, 0 ; fd du clavier si j'ai bien compris
    mov rsi, keys ; adresse du buffer ou placer la valeur récupéré par sys_read
    mov rdx, NB_OCTETS_TO_READ
    syscall

display_keys:
    mov rax, 1
    mov rdi, 1
    mov rsi, keys
    mov rdx, NB_OCTETS_TO_READ
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; nasm -f elf64 ecouter_une_touche.asm ; ld ecouter_une_touche.o -o ecouter_une_touche ; ./ecouter_une_touche