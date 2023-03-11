section .text
global main:

VIDEOMEM equ 0xb8000
COLOR equ 0x0f

main:
	mov ebx, hello
	call print_screen
	ret 
hello:
	db "Hello, kernel! You can use the command 'stack' to print the stack!", 0x00

print_screen:
	pusha
	mov edx, VIDEOMEM
.print_loop:
	mov al, [ebx]
	mov ah, COLOR
	
	cmp al, 0
	je .print_end

	mov [edx], ax

	inc ebx
	add edx, 2			;character + color
	jmp .print_loop
.print_end:
	popa
	ret

