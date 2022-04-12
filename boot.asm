ORG	0x7c0
BITS 	16
_start:
	jmp short step1		;salto al programa para poder asignar a 0 los siguientes 33 bytes,
	nop			;que constituyen el BPB y deben ser asignados para evitar
				;que el programa use estas posiciones, ya que según qué tipos de
times 33 db 0 			;BIOS se utilice, puede reescribir alguno de estos 33 bytes

step1:
	jmp 0:step2	

step2:
	cli			;desactiva interrupciones
	mov ax, 0		;asigna segmentos de datos, extra y de pila
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00		;asigna puntero de pila a su origen
	sti			;activa interrupciones
	
	jmp $


;GDT
gdt_start:
gdt_null:			;puesta a cero de los 64 bits de la GDT
	dd 0x00
	dd 0x00

;offset 0x8
gdt_code:			;el registro CS debe apuntar aquí
	dw 0xffff		;límite de segmento, primera palabra 0-15 de límite, 0-15 del descriptor de segmento 
	dw 0			;primera palabra de la base, 0-15, 16-31 del descriptor de segmento
	db 0			;último byte de la base, 16-23, 32 a 39 del descriptor de segmento
	db 0x9a			;byte de acceso, 40-47 del descriptor de segmento
	db 11001111b		;4 bits de flags, 52-55 del descriptor y 4 bits altos de límite, 48-51 del descriptor
	db 0			;byte superior de la base, 56-63 del descriptor de segmento
;offset 0x10
gdt_data:			;DS, SS, ES, FS, GS
	dw 0xffff
	dw 0
	db 0
	db 0x92			;cambia el bit 3 para indicar segmento de datos en lugar de código
	db 11001111b
	db 0

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start-1	;tamaño del descriptor
	dd gdt_start			;tamaño del offset


print:
	mov bx, 0
.loop:
	lodsb
	cmp al, 0
	je .done
	call print_char
	jmp .loop
.done:	
	ret

print_char:
	mov ah, 0eh
	int 0x10
	ret

message: db 'Welcome to sotOS!', 0

times 510-($ - $$) db 0
dw 0xAA55

