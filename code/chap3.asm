section .text
    global _start

_start:
    mov al, 5 ; pourquoi meme si je fais ça il le place dans rax ? (je l'ai vue sur gdb)
    mov bl, 7
    add al, bl

    mov rax, 60
    xor rdi, rdi ; pourquoi il faut mettre rdi à 0 ?
    syscall