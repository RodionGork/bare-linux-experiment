.macro sys_call
int $0x80
.endm

.section .data
msg: .ascii "Hello from nedo-bash!\n\0"
nl: .ascii "\n\0"
strbuf: .fill 128

.section .text
.global _start

_start:
    movl $msg, %ecx
    call puts
again:
    movl $strbuf, %ecx
    call gets
    call strlen
    movl $strbuf, %ecx
    call itoa
    movl $strbuf, %ecx
    call puts
    movl $nl, %ecx
    call puts
    jmp again

puts:       # string in ecx
    call strlen
    movl %eax, %edx
    movl $4, %eax
    movl $1, %ebx
    sys_call
    ret

gets:        # buffer in ecx
    push %ecx
gets_next:
    movl $3, %eax
    movl $0, %ebx
    movl $1, %edx
    sys_call
    movb (%ecx), %al
    inc %ecx
    cmp $10, %al
    jnz gets_next
    dec %ecx
    movb $0, (%ecx)
    pop %ecx
    ret

strlen:      # string in ecx
    push %ecx
strlen_n:
    cmpb $0, (%ecx)
    jz  strlen_z
    inc %ecx
    jmp strlen_n
strlen_z:
    movl %ecx, %eax
    pop %ecx
    sub %ecx, %eax
    ret

itoa:        # buffer in ecx, number in eax
    push %ecx
itoa_next:
    movl $0, %edx
    movl $10, %ebx
    div %ebx
    add $'0', %dl
    movb %dl, (%ecx)
    inc %ecx
    cmp $0, %eax
    jne itoa_next
    movb $0, (%ecx)
    dec %ecx
    pop %ebx
itoa_rev:
    cmp %ebx, %ecx
    jl itoa_done
    movb (%ebx), %al
    movb (%ecx), %ah
    movb %al, (%ecx)
    movb %ah, (%ebx)
    inc %ebx
    dec %ecx
    jmp itoa_rev
itoa_done:
    ret

exit0:
    movl $1, %eax
    movl $0, %ebx
    sys_call
