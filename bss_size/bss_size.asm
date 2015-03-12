section .bss
    mem resb 1
 
section .text
    global _start
_start:

	mov r9, 25 ; count 
	mov r11, mem ; starting address in memory
mem_loop:
	add r9, 1
	add r11, 1
	mov byte [r11], 0xFF
	push r9
	call convert_number
	jmp mem_loop

convert_number:
	push rbp
	mov rbp, rsp
	push r8 ; callee save
	push r9 ; callee save
	push r10 ; callee save

	mov r8, [rbp + 16] ; get the parameter

	mov r10, rsp ; save the original stack pointer position
	push 0 ; end of the number

divide_loop:
	mov r9, 0 ; result of divide
	cmp r8, 0
	je end_divide

mod_loop:
	sub r8, 10
	js end_mod
	add r9, 1
	jmp mod_loop
end_mod:

	add r8, 10
	add r8, 0x30 ; convert to ascii number
	push r8
	mov r8, r9
	jmp divide_loop
end_divide:

	call write_word

	mov rsp, r10 ; restore the stack pointer

	pop r10 ; callee save
	pop r9 ; callee save
	pop r8 ; callee save

    mov rbp, [rbp + 8] ; get return address
    mov [rsp + 16], rbp ; restore return address
    pop rbp
    add rsp, 8 ; account for parameter
    ret

write_word:
	push r8 ; callee save

	mov r8, rsp
	add r8, 16 ; address of the first letter

write_loop:
	cmp byte [r8], 0
	je end_write
	push r8
	call write
	add r8, 8
	jmp write_loop
end_write:

	pop r8 ; callee save
    ret

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

    mov rbp, [rbp + 8] ; get return address
    mov [rsp + 16], rbp ; restore return address
    pop rbp
    add rsp, 8 ; account for parameter
    ret

exit:
    mov    rax, 60
    mov    rdi, 0
    syscall