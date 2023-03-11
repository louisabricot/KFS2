[BITS 32]

section .text
global start
global stack_top

extern main
extern init_gdt

start:
	mov esp, stack_top	    ;set stack pointer
	call init_gdt
	call main
	hlt			            ;halt the CPU

section .bss
resb 8192					;8KB for stack
stack_top:
