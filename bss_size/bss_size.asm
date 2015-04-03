section .bss
    string resq 50
    string_end resb 0
 
section .text
    global _start
_start:
;----- main -----
	
	mov r9, 0
	mov r8, string

mem_loop:
	add r9, 1
	mov r10, qword [r8] ; will segfault beyond limit of heap block
	add r8, 1
	push string_end
	push r9
	call bin_to_dec
	call write_string
	add rsp, 16
	jmp mem_loop

;----- print an ascii array -----
write_string:
	push rbp
	mov rbp, rsp
	push r8 ; callee save

	mov r8, [rbp + 16] ; get the parameter

write_loop:
	cmp qword [r8], 0
	je end_write_loop
	push r8
	call write
	pop r8
	add r8, 8
	jmp write_loop
end_write_loop:

	pop r8 ; callee save
	pop rbp
	ret

;----- convert a binary parameter to decimal ascii array -----
bin_to_dec:
	push rbp
	mov rbp, rsp
	push r8 ; callee save
	push r9 ; callee save
	push r10 ; callee save

	mov r8, [rbp + 24] ; address of last available memory
	mov r9, [rbp + 16] ; number to convert

	sub r8, 8
	mov qword [r8], 0 ; last letter
	sub r8, 8
	mov qword [r8], 10 ; new line

divide_loop:
	mov r10, 0 ; quotient
	cmp r9, 0
	je end_divide_loop

mod_loop:
	sub r9, 10
	js end_mod_loop
	add r10, 1
	jmp mod_loop
end_mod_loop:

	add r9, 10 ; make r9 positive
	add r9, 0x30 ; add ascii offset
	sub r8, 8
	mov qword [r8], r9
	mov r9, r10 ; make the quotient the new numerator
	jmp divide_loop
end_divide_loop:

	mov [rbp + 16], r8 ; return value (the beginning address of the ascii array)

    pop r10 ; callee save
    pop r9 ; callee save
    pop r8 ; callee save
    pop rbp
    ret

;----- read from terminal -----
read:
	push rbp
	mov rbp, rsp
	push r8 ; callee save

	mov r8, [rbp + 16] ; get the parameter

	mov rax, 0
	mov rdi, 1
	mov rsi, r8
	mov rdx, 1
	syscall

	pop r8 ; callee save
	pop rbp
	ret

;----- write ascii characters -----
write:
	push rbp
	mov rbp, rsp
	push r8 ; callee save

	mov r8, [rbp + 16] ; get the parameter

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    pop r8 ; callee save
    pop rbp
    ret

;----- exit -----
exit:
    mov    rax, 60
    mov    rdi, 0
    syscall