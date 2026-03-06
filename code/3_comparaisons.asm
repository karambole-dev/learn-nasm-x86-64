section .text
    global _start

_start:
    mov rax, 30
    mov rbx, 20
    cmp rax, rbx
    ja rax_plus_grand_que_rbx
    mov rax, 60
    xor rdi, 1
    syscall

rax_plus_grand_que_rbx:
    mov rax, 60
    xor rdi, rdi
    syscall

; $ nasm -f elf64 exo2.asm ; ld exo2.o -o exo2 ; ./exo2 
; $ echo $?
; 1
; $ nasm -f elf64 exo2.asm ; ld exo2.o -o exo2 ; ./exo2 
; echo $?
; 0