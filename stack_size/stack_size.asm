section .text
    global _start
_start:

	mov r8, 0x38393a3b3c3d3e3f
	push r8
	mov r8, 0x3031323334353637
	push r8
	mov r8, rsp
	add r8, 15
	call write
	call exit

write:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, r8
    mov     rdx, 1
    syscall
    ret

exit:
    mov    rax, 60
    mov    rdi, 0
    syscall