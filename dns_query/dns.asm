section .data
    fd dq 0

ip_socket:
    dw 2              ; AF_INET
    dw 0x3500         ; port 53 (network order)
    dd 0x08080808     ; 8.8.8.8
    dq 0              ; padding

dns_query:
    db 0x12,0x34        ; ID
    db 0x01,0x00        ; Flags (standard query RD=1)
    db 0x00,0x01        ; QDCOUNT
    db 0x00,0x00        ; ANCOUNT
    db 0x00,0x00        ; NSCOUNT
    db 0x00,0x00        ; ARCOUNT

    db 11,"testdomaine"
    db 3,"com"
    db 0

    db 0x00,0x01        ; QTYPE A
    db 0x00,0x01        ; QCLASS IN


query_len equ $-dns_query

section .text
    global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    mov rdx, 17
    syscall

    mov [fd], rax

    mov rax, 44
    mov rdi, [fd]
    mov rsi, dns_query
    mov rdx, query_len
    xor r10, r10
    mov r8, ip_socket
    mov r9, 16
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall