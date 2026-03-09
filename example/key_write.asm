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

write_key:
    mov rax, 2 ; sys_open()
    mov rdi, filename
    mov rsi, 2 | 64 | 1024  ; O_WRONLY | O_CREAT | O_APPEND
    mov rdx, 0777o        ; Permissions
    syscall

    ; après l’exécution du syscall, rax contient le résultat
    ; il crée un fd (autre que ceux standard) et le sys_write écrit dedans
    mov rbx, rax

    mov rax, 1 ; sys_write()
    mov rdi, rbx
    mov rsi, keys
    mov rdx, NB_OCTETS_TO_READ
    syscall

    mov rax, 3 ; sys_close()
    mov rdi, rbx
    syscall


exit:
    mov rax, 60
    xor rdi, rdi
    syscall


; nasm -f elf64 key_write.asm ; ld key_write.o -o key_write ; ./key_write