;section .data
;    msg db      "hello, world!"

; section .bss
;     string resb 1
 
section .text
    global _start
_start:

	push 0 ; end of word
	push 10 ; newline
read_loop:
	push 0
	mov r8, rsp
	call read
	cmp byte [r8], 10 ; end input on enter key
	jnz read_loop

	pop r8

	mov r8, rsp

write_loop:
	cmp byte [r8], 0
	jz exit_loop
	push r8
	call write
	add r8, 8
	jmp write_loop

exit_loop:
    call exit

read:
	mov rax, 0
	mov rdi, 1
	mov rsi, r8
	mov rdx, 1
	syscall
	ret

write:
	mov rbp, rsp
	push r8 ; callee save

	mov r8, [rsp + 16] ; get the parameter

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    pop r8 ; callee save

    add rsp, 8 ; account for parameter
    mov rbp, [rbp] ; get return address
    mov [rsp], rbp ; restore return address
    ret

exit:
    mov    rax, 60
    mov    rdi, 0
    syscall