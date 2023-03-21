[BITS 32]

PROTECTION_ENABLED equ 0x1
KDATA_OFFSET equ 0x10

section .text
global init_gdt

init_gdt:
	lgdt [gdtr]                 ; Load GDT
.reload:
	mov ax, KDATA_OFFSET		;offset in the GDT to data segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x08:.flush				;far jump to reload our new code segment
.flush:
	ret

struc gdt_entry
	limit_low:			resb	2
	base_low:			resb	2
	base_middle:		resb	1
	access:				resb	1
	granularity:		resb	1
	base_high:			resb	1
endstruc

align 8
section .gdt
gdt_start:
	null:
		istruc gdt_entry
			at limit_low, dw	0
			at base_low, dw		0
			at base_middle, db	0
			at access, db		0
			at granularity, db	0
			at base_high, db	0
		iend
	kcode:
		istruc gdt_entry
			at limit_low, dw	0xFFFF
			at base_low, dw		0x0
			at base_middle, db	0x0
			at access, db		0x9A ;PRESENT | CODE | EXECUTE | READ
			at granularity, db	0xCF ;PAGE_GRANULARITY | 32-BIT PM
			at base_high, db	0x0
		iend
	kdata:
		istruc gdt_entry
			at limit_low, dw	0xFFFF
			at base_low, dw		0x0
			at base_middle, db	0x0
			at access, db		0x92 ;PRESENT | DATA | WRITE
			at granularity, db	0xCF ;PAGE_GRANULARITY | 32-BIT PM
			at base_high, db	0x0
		iend
	kstack:
		istruc gdt_entry
			at limit_low, dw	0xFFFF
			at base_low, dw		0x0
			at base_middle, db	0x0
			at access, db		0x97 ;PRESENT | DATA_SEG | GROWS_DOWN | WRITE 
			at granularity, db	0xCF ;PAGE_GRANULARITY | 32-BIT PM	
			at base_high, db	0x0
		iend
	ucode:
		istruc gdt_entry
			at limit_low, dw	0xFFFF
			at base_low, dw		0x0
			at base_middle, db	0x0
			at access, db		0xFA ;PRESENT | USER | CODE | EXECUTE | READ
			at granularity, db	0xCF ;PAGE_GRANULARITY | 32-BIT PM
		
			at base_high, db	0x0
		iend
	udata:
		istruc gdt_entry
			at limit_low, dw	0xFFFF
			at base_low, dw		0x0
			at base_middle, db	0x0
			at access, db		0xF2 ;PRESENT | USER | DATA | WRITE
			at granularity, db	0xCF ;PAGE_GRANULARITY | 32-BIT PM
			at base_high, db	0x0
		iend
	ustack:
		istruc gdt_entry
			at limit_low, dw	0xFFFF
			at base_low, dw		0x0
			at base_middle, db	0x0
			at access, db		0xF7 ;PRESENT | DATA | GROWS_DOWN | WRITE
			at granularity, db	0xCF ;PAGE_GRANULARITY | 32-BIT PM	
			at base_high, db	0x0
		iend
gdt_end:

gdtr:
    dw gdt_end - gdt_start - 1  ; Size of gdt - 1
    dd gdt_start                ; Address of gdt
