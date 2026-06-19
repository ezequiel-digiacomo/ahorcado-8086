.8086
.model tiny
.code
org 100h

Start:
    jmp Main

;----------------------------------------------------------
; ISR INT 60h - Ruidito (Beep) fachero
;----------------------------------------------------------

BeepISR PROC FAR

    push ax
    push bx

    cmp ah,1
    jne Salir

    mov al,10110110b
    out 43h,al

    mov ax,1000

    out 42h,al
    mov al,ah
    out 42h,al

    in al,61h
    or al,00000011b
    out 61h,al

    mov bx,3000

Espera:
    dec bx
    jnz Espera

    in al,61h
    and al,11111100b
    out 61h,al

Salir:

    pop bx
    pop ax
    iret

BeepISR ENDP

;----------------------------------------------------------
; Datos de la ISR
;----------------------------------------------------------

ViejaInt60 		LABEL DWORD
DespInt60 		DW 0
SegInt60  		DW 0

FinResidente LABEL BYTE

;----------------------------------------------------------
; Datos del instalador
;----------------------------------------------------------

Mensaje DB 13,10,"INT 60h instalada.$"

Main:
    mov ax,cs
    mov ds,ax
    mov es,ax

InstalarInt:
    mov ax,3560h
    int 21h

    mov DespInt60,bx
    mov SegInt60,es

    mov ax,2560h
    mov dx,OFFSET BeepISR
    int 21h

Mostrar:
    mov dx,OFFSET Mensaje
    mov ah,09h
    int 21h

DejarResidente:
    mov ax,(15 + OFFSET FinResidente)

    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1

    mov dx,ax

    mov ax,3100h
    int 21h

END Start