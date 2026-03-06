section .data ; declare la section mémoire des données initialisées

    ; place dans l'adresse mémoire contenant l'étiquette msg les octets (define byte) du message et 10 qui est le numéro ascii du retour à la ligne
    msg db "Hello, world!", 10

    ; récupère la longueur du message, j'ai pas encore bien compris comment
    ; $ = adresse courante (juste après le message)
    ; msg = adresse du début
    ; $ - msg = distance en octets
    ; len equ $ - msg
    len equ 14

section .text
    ; section du code, renvoie vers _start j'ai pas bien compris pk
    global _start

_start:
    ; tout cette partie va servir à préparer un syscall et ces arguments
    ; rax	numéro syscall
    ; rdi	argument 1
    ; rsi	argument 2
    ; rdx	argument 3

    mov rax, 1 ; sys_write
    mov rdi, 1 ; file descriptor, 1 = stdout donc on écrit sur l’écran
    mov rsi, msg ; adresse du buffer
    mov rdx, len ; nombre d'octet à écrire
    syscall ; demande au kernel Linux d’exécuter sys_write

    mov rax, 60 ; sys_exit
    xor rdi, rdi ; reset rdi à 0
    syscall