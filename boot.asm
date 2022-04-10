ORG	0
BITS 	16
_start:
	jmp short step1		;salto al programa para poder asignar a 0 los siguientes 33 bytes,
	nop			;que constituyen el BPB y deben ser asignados para evitar
				;que el programa use estas posiciones, ya que según qué tipos de
times 33 db 0 			;BIOS se utilice, puede reescribir alguno de estos 33 bytes

step1:
	jmp 0x7c0:step2		;asgina 0x7c0 al segmento de código de step2 y salta a dicha parte

step2:
	cli			;desactiva interrupciones
	mov ax, 0x7c0		;asigna segmento de datos y segmento extra
	mov ds, ax
	mov es, ax
	mov ax, 0x00		;el puntero de pila empieza en 0x7c0
	mov ss, ax
	mov sp, 0x7c00
	sti			;activa interrupciones
	
	jmp $

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

