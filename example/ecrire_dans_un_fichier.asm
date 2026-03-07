section .data
    filename db "output.txt", 0
    message db "Hello, World!", 10
    msg_len equ $ - message

section .text
    global _start

_start:
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
    mov rsi, message
    mov rdx, msg_len
    syscall

    mov rax, 3 sys_close()
    mov rdi, rbx
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall