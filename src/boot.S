[BITS 32]

section .text
global start
global stack_top

extern print_stack
extern init_gdt

start:
	pusha
	mov esp, stack_top	    ;set stack pointer
	call init_gdt
	push stack_top
	call print_stack
	popa
	hlt			            ;halt the CPU

section .bss
resb 8192					;8KB for stack
stack_top:
