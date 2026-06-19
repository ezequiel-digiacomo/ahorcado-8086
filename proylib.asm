.8086
.model small
.stack 100h
; ----------------------------------------
; INDICE DE FUNCIONES PARA EL PROYECTO
;
; 1) Funciones generales.
;	1.1) Salto de línea
;   1.2) Leer carácter
;   1.3) Convertir a mayúscula
;   1.4) Limpiar pantalla
; 	1.5) Carga 03h
;	1.6) Impresión 03h
;	1.7) Largo cadena de texto 03h
;	1.8) Mover cursor
;
; 2) Funciones del juego.
;	2.1) Iniciar partida
;	2.2) Buscar letra
;	2.3) Descontar intentos
;	2.4) Verificar victoria
;	2.5) Verificar derrota
;	2.6) Guardar letra
;	2.7) Reiniciar intentos
;
; 3) Funciones gráficas.
;	3.1) Mostrar estado
;	3.2) Mostrar ahorcado
;	3.3) Mostrar victoria
;	3.4) Mostrar derrota
;	3.5) Mostrar arte GANASTE
;	3.6) Mostrar arte PERDISTE
;	3.7) Mostrar salida
;
; 4) Funciones menú
;	4.1) Mostrar menú
;	4.2) Mostrar créditos
; ----------------------------------------
.data
	palabra_real      	   db 30 dup(03h)
	palabra_oculta    	   db 30 dup(03h)

	intentos          	   db 6

	partidas          	   db 0
	ganadas           	   db 0
	perdidas          	   db 0
	racha             	   db 0

	letra_ingresada   	   db ?
	letras_usadas     	   db 27 dup(03h)

;-------Palabras para el Random-------
	palabra0          		db "PRUEBA", 03h
	palabra1          		db "TECLADO", 03h
	palabra2          		db "REGISTRO", 03h
	palabra3          		db "MEMORIA", 03h
	palabra4          		db "PROCESO", 03h
	palabra5          		db "PILA", 03h
	palabra6          		db "BUFFER", 03h
	palabra7          		db "VARIABLE", 03h
	palabra8          		db "HEXADECIMAL", 03h
	palabra9          		db "MICROPROCESADOR", 03h
	palabra10          		db "INTERRUPCION", 03h
	palabra11          		db "PIPELINE", 03h
	palabra12          		db "MULTIPLEXADO", 03h
	palabra13          		db "PUNTERO", 03h
	palabra14          		db "SEGMENTO", 03h
	palabra15          		db "ALGORITMO", 03h
	palabra16          		db "LIBRERIA", 03h
	palabra17          		db "DEBUGGER", 03h
	palabra18          		db "HARDWARE", 03h
	palabra19          		db "SOFTWARE", 03h
	palabra20          		db "JUMP", 03h
	palabra21          		db "INTEL", 03h
	palabra22          		db "CARRY", 03h
	palabra23          		db "FLAG", 03h
	palabra24          		db "PERIFERICO", 03h
	palabra25          		db "BLOQUE", 03h
	palabra26          		db "RAFAGA", 03h
	palabra27          		db "MASCARA", 03h
	palabra28          		db "PETICION", 03h
	palabra29          		db "MAESTRO", 03h
	palabra30          		db "ESCLAVO", 03h

	tablaPalabras     		dw palabra0, palabra1, palabra2, palabra3, palabra4, palabra5, palabra6, palabra7, palabra8, palabra9, palabra10, palabra11, palabra12, palabra13, palabra14, palabra15, palabra16, palabra17, palabra18, palabra19, palabra20, palabra21, palabra22, palabra23, palabra24, palabra25, palabra26, palabra27, palabra28, palabra29, palabra30	; array de offsets (2 bytes c/u)
;-------Palabras para el Random-------

;-------ASCII-------
	msj_letras_usadas		db "Letras Usadas: ", 03h

	msj_titulo_palabra		db "Palabra: ", 03h
	msj_titulo_intentos		db "Intentos: ", 03h
	msj_mostrar_victoria	db "GG! Ganaste :D", 03h
	msj_mostrar_oculta		db "La palabra era: ", 03h
	msj_letra_ingresada		db "Ingresa una letra: ", 03h

	; --------------------------
	; ASCII ART - HASTA LA PROXIMA
	; --------------------------

	; --------------------------
	; ASCII ART - GANASTE
	; --------------------------
	art_g_l1	db " @@@   @@@  @   @  @@@   @@@@ @@@@@ @@@@@ ", 03h
	art_g_l2	db "@     @   @ @@  @ @   @ @       @   @     ", 03h
	art_g_l3	db "@  @@ @@@@@ @ @ @ @@@@@  @@@    @   @@@@  ", 03h
	art_g_l4	db "@   @ @   @ @  @@ @   @     @   @   @     ", 03h
	art_g_l5	db " @@@  @   @ @   @ @   @ @@@@    @   @@@@@ ", 03h

	; --------------------------
	; ASCII ART - PERDISTE
	; --------------------------
	art_p_l1	db " ____   ____  ____   ____  ____  ____  ____  ____", 03h
	art_p_l2	db "|  _ \ | ___||  _ \ |  _ \|_  _|/ ___||_  _||  __|", 03h
	art_p_l3	db "| |_) || _|  | |_) || | | || |  \__ \  | |  | _|", 03h
	art_p_l4	db "|  __/ | |___| |/ / | |_| || |   ___) || |  | |__", 03h
	art_p_l5	db "|_|    |____||_|\_\ |____/|___| |____/ |_|  |____|", 03h

	; --------------------------
	; AHORCADO - 6 intentos
	; --------------------------
	a6_l1 					db " +---+",03h
	a6_l2 					db " |   |",03h
	a6_l3 					db "     |",03h
	a6_l4 					db "     |",03h
	a6_l5 					db "     |",03h
	a6_l6 					db "=======",03h

	; --------------------------
	; AHORCADO - 5 intentos
	; --------------------------
	a5_l1 					db " +---+",03h
	a5_l2 					db " |   |",03h
	a5_l3 					db " O   |",03h
	a5_l4 					db "     |",03h
	a5_l5 					db "     |",03h
	a5_l6 					db "=======",03h

	; --------------------------
	; AHORCADO - 4 intentos
	; --------------------------
	a4_l1 					db " +---+",03h
	a4_l2 					db " |   |",03h
	a4_l3 					db " O   |",03h
	a4_l4 					db " |   |",03h
	a4_l5 					db "     |",03h
	a4_l6 					db "=======",03h

	; --------------------------
	; AHORCADO - 3 intentos
	; --------------------------
	a3_l1 					db " +---+",03h
	a3_l2 					db " |   |",03h
	a3_l3 					db " O   |",03h
	a3_l4 					db "/|   |",03h
	a3_l5 					db "     |",03h
	a3_l6 					db "=======",03h

	; --------------------------
	; AHORCADO - 2 intentos
	; --------------------------
	a2_l1 					db " +---+",03h
	a2_l2 					db " |   |",03h
	a2_l3 					db " O   |",03h
	a2_l4 					db "/|\  |",03h
	a2_l5 					db "     |",03h
	a2_l6 					db "=======",03h

	; --------------------------
	; AHORCADO - 1 intento
	; --------------------------
	a1_l1 					db " +---+",03h
	a1_l2 					db " |   |",03h
	a1_l3 					db " O   |",03h
	a1_l4 					db "/|\  |",03h
	a1_l5 					db "/    |",03h
	a1_l6 					db "=======",03h

	; --------------------------
	; AHORCADO - 0 intentos
	; --------------------------
	a0_l1 					db " +---+",03h
	a0_l2 					db " |   |",03h
	a0_l3 					db " O   |",03h
	a0_l4 					db "/|\  |",03h
	a0_l5 					db "/ \  |",03h
	a0_l6 					db "=======",03h


	; -----------------------------------
	; Cadenas de textos para el menú :D
	; -----------------------------------

	titulo_menu         db 0dh,0ah
	                    db '+==================================+',0dh,0ah
	                    db '|       AHORCADO 8086 <3           |',0dh,0ah
	                    db '+==================================+',0dh,0ah
	                    db 03h

	op_jugar            db '| 1) Jugar                         |',0dh,0ah
						db '|                                  |',0dh,0ah,03h

	op_estadisticas     db '| 2) Estadisticas                  |',0dh,0ah
						db '|                                  |',0dh,0ah,03h

	op_creditos         db '| 3) Creditos                      |',0dh,0ah
						db '|                                  |',0dh,0ah,03h

	op_salir            db '| 4) Salir                         |',0dh,0ah,03h

	pedir_opcion        db '+==================================+',0dh,0ah
	                    db '  Seleccione una Opcion: '
	                    db 03h

	titulo_estadisticas db 0dh,0ah
	                    db '+===================================+',0dh,0ah
	                    db '|           ESTADISTICAS            |',0dh,0ah
	                    db '+===================================+',0dh,0ah
	                    db 03h

	msj_partidas        db '| Partidas jugadas: ', 03h
	msj_ganadas         db '| Ganadas: ', 03h
	msj_perdidas        db '| Perdidas: ', 03h
	msj_racha           db '| Racha: +', 03h
	msj_cierre_partidas db '              |', 0dh, 0ah, 03h
	msj_cierre_ganadas  db '                       |', 0dh, 0ah, 03h
	msj_cierre_perdidas db '                      |', 0dh, 0ah, 03h
	msj_cierre_racha    db '                        |', 0dh, 0ah, 03h
	msj_linea_vacia     db '|                                   |', 0dh, 0ah, 03h
	msj_cierre_est      db '+===================================+',0dh,0ah
	                    db '  Presione una tecla para volver...'
	                    db 03h

	titulo_creditos     db 0dh,0ah
	                    db '+====================================+',0dh,0ah
	                    db '|           CREDITOS :D              |',0dh,0ah
	                    db '+====================================+',0dh,0ah
	                    db 03h

	cred1               db '| Sistema de Procesamiento de Datos  |',0dh,0ah
	                    db '|                                    |',0dh,0ah,03h

	cred2               db '| Desarrollado por:                  |',0dh,0ah,03h

	cred3               db '|  - Ezequiel Di Giacomo Insua       |',0dh,0ah
	                    db '|  - Lemmy Nehuen Wolter             |',0dh,0ah,03h

	opc_volver_menu     db '+====================================+',0dh,0ah
	                    db '  Presione una tecla para volver...'
	                    db 03h

	separador			db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 03h
;-------ASCII-------

.code
	public salto_linea
	public leer_caracter
	public convertir_mayus
	public limpiar_pantalla
	public carga_03h
	public impresion_03h
	public largo_cadena_03h
	public iniciar_partida
	public mostrar_estado
	public buscar_letra
	public descontar_intentos
	public verificar_victoria
	public verificar_derrota
	public mostrar_derrota
	public mostrar_victoria
	public mostrar_ahorcado
	public mostrar_perdiste_art
	public mostrar_ganaste_art
	public mostrar_salida
	public guardar_letra
	public mover_cursor
	public mostrar_menu
	public mostrar_creditos
	public mostrar_estadisticas
	public reiniciar_intentos
	public inc_ganadas
	public inc_perdidas

; ----------------------------------------
; 1) FUNCIONES GENERALES
; ----------------------------------------

	salto_linea proc 					; 1.1) Salto de línea
		push ax
		push dx

		mov ah, 02h
		mov dl, 0dh
		int 21h

		mov ah, 02h
		mov dl, 0ah
		int 21h

		pop dx
		pop ax
		ret 
	salto_linea endp

	leer_caracter proc					; 1.2) Leer carácter (mov ah, 01h peeeero acortado a funcion)
	    mov ah,01h
	    int 21h

	    ret
	leer_caracter endp

	convertir_mayus proc 				; 1.3) Convertir a mayúscula
		cmp al,'a'
		jb fin

		cmp al,'z'
		ja fin

		sub al, 32

		fin:
			ret
	convertir_mayus endp

	limpiar_pantalla proc 				; 1.4) Limpiar pantalla
	    push ax

	    mov ax,0003h
	    int 10h

	    pop ax
	    ret
	limpiar_pantalla endp

	mover_cursor proc					; 1.8) Mover cursor — DH=fila, DL=columna
	    push ax
	    push bx

	    mov ah, 02h
	    mov bh, 0					; pagina de video 0
	    int 10h

	    pop bx
	    pop ax
	    ret
	mover_cursor endp

	carga_03h proc          			; 1.5) Carga 03h

		push bp             ; Función que permite cargar en un offset y al finalizar ingresa un 03h
		mov bp, sp

		push bx
		push si
		mov bx, ss:[bp+4]	; Rescato el offset del texto a cargar
		mov si, bx			; Guardo en SI el offset para recordar donde inicié

		proceso_carga_03h:
			mov ah, 01h
			int 21h

			cmp al, 08h		; Comparo si toca backspace
			je backspace_carga_03h

			cmp al, 0dh		; Comparo si toca enter
			je fin_carga_03h

			mov [bx], al
			inc bx
			jmp proceso_carga_03h

		backspace_carga_03h:
			cmp bx, si		; Comparo si es el inicio del offset para evitar que borre de más
			je proceso_carga_03h
			dec bx
			mov byte ptr [bx], 03h

			mov ah, 02h		; Proceso para mostrar en pantalla que se "borró" el caracter
			mov dl, 20h
			int 21h
			mov ah, 02h
			mov dl, 08h
			int 21h

			jmp proceso_carga_03h
		fin_carga_03h:
			mov byte ptr [bx], 03h   ; Cierro con un 03h

			pop si
			pop bx
			pop bp
			ret 2
	carga_03h endp

	impresion_03h proc          		; 1.6) Impresión 03h
		push bp
		mov bp, sp

		push bx
		push ax
		push dx

		mov bx, ss:[bp+4]	; Rescato el offset a imprimir

		proceso_impresion_03h:
			cmp byte ptr [bx], 03h
			je fin_impresion_03h

			mov ah, 02h
			mov dl, [bx]
			int 21h

			inc bx
			jmp proceso_impresion_03h

		fin_impresion_03h:
			pop dx
			pop ax
			pop bx
			pop bp
			ret 2
	impresion_03h endp

	largo_cadena_03h proc 				; 1.7) Largo cadena de texto 03h
	    push bp
	    mov bp, sp 						; Guarda en AL el conteo

	    push bx

	    mov bx, [bp+4]					; Recibe el offset del largo de la cadena a saber
	    mov ax, 0

		proceso_largo_cadena_03h:
		    cmp byte ptr [bx], 03h
		    je fin_largo_cadena_03h

		    inc ax
		    inc bx
		    jmp proceso_largo_cadena_03h

		fin_largo_cadena_03h:
		    pop bx
		    pop bp
		    ret 2
	largo_cadena_03h endp

; ----------------------------------------
; 2) FUNCIONES DEL JUEGO
; ----------------------------------------
	obtenerPalabraAleatoria proc
		push bx
		push si
		push dx

		mov ah, 00h
		int 1Ah						; iint de BIOS: guarda en CX:DX el tiempo transcurrido

		mov al, dl					; tomamos solo DL (byte bajo) 
		xor ah, ah			
		mov bl, 31
		div bl						; dividimos por 31 (cantidad de palabras) — el resto en AH vale 0..30 = nuestro "random"

		xor bh, bh
		mov bl, ah					; movemos el resto a BX para usarlo como indice
		shl bx, 1					; multiplicamos por 2 porque cada entrada de la tabla ocupa 2 bytes (son direcciones, no caracteres)

		mov bx, tablaPalabras[bx]	; buscamos en la tabla la direccion de la palabra sorteada y la guardamos en BX

		mov si, 0
		copiar_palabra:
			mov al, [bx]
			mov palabra_real[si], al	; copia byte a byte hacia palabra_real
			cmp al, 03h
			je fin_copiar_palabra
			inc bx
			inc si
			jmp copiar_palabra

		fin_copiar_palabra:
		pop dx
		pop si
		pop bx
		ret
	obtenerPalabraAleatoria endp

	guardar_letra proc
		push bx
		push dx

		mov dl, al          		; guardamos la letra para no perderla durante el recorrido

		mov bx, 0
		buscar_repetida:
			cmp letras_usadas[bx], 03h
			je es_nueva
			cmp letras_usadas[bx], dl
			je es_repetida
			inc bx
			jmp buscar_repetida

		es_nueva:
			mov letras_usadas[bx], dl
			inc bx
			mov letras_usadas[bx], 03h
			mov al, 1
			jmp fin_guardar_letra

		es_repetida:
			mov al, 0

		fin_guardar_letra:
		pop dx
		pop bx
		ret
	guardar_letra endp

	iniciar_partida proc
		call obtenerPalabraAleatoria	; cargamos en memoria la palabra_real
		mov byte ptr letras_usadas[0], 03h	; limpiamos letras usadas de la partida anterior
		push bx
		push cx

		lea bx, palabra_real
		push bx
		call largo_cadena_03h

		mov cx, ax
		lea bx, palabra_oculta

		ocultamiento:
			mov byte ptr [bx], '_'
			inc bx
			loop ocultamiento

		mov byte ptr [bx], 03h

		pop cx
		pop bx
		ret
	iniciar_partida endp

	mostrar_estado proc
	    call limpiar_pantalla
	    push ax
	    push bx
	    push dx

	    call mostrar_ahorcado		; ocupa filas 0..5, columnas 0..6

	    ; fila 1, col 10 — Palabra
	    mov dh, 1
	    mov dl, 10
	    call mover_cursor
	    lea bx, msj_titulo_palabra
	    push bx
	    call impresion_03h
	    lea bx, palabra_oculta
	    push bx
	    call impresion_03h

	    ; fila 3, col 10 — Intentos
	    mov dh, 1
	    mov dl, 40
	    call mover_cursor
	    lea bx, msj_titulo_intentos
	    push bx
	    call impresion_03h
	    mov al, intentos
	    add al, '0'
	    mov dl, al
	    mov ah, 02h
	    int 21h

	    ; fila 3, col 23 — Letras usadas
	    mov dh, 3
	    mov dl, 10
	    call mover_cursor
	    lea bx, msj_letras_usadas
	    push bx
	    call impresion_03h
	    lea bx, letras_usadas
	    push bx
	    call impresion_03h

	    mov dh,6
	    mov dl,0
	    call mover_cursor
	    lea bx,separador  					; Separador inferior
	    push bx
	    call impresion_03h

	    ; mover cursor debajo del ahorcado para el input
	    mov dh, 7
	    mov dl, 0
	    call mover_cursor
	    lea bx, msj_letra_ingresada
	    push bx
	    call impresion_03h

	    pop dx
	    pop bx
	    pop ax
	    ret
	mostrar_estado endp

	buscar_letra proc
	    push bx				
	    push dx 			; En AL estaría el carácter encontrado al principio, después avisa en la salida tmb por AL si hubo o no coincidencia

	    mov dl,0          	; 0 = no encontró
	    mov bx,0

		proceso_buscar_letra:
		    cmp palabra_real[bx],03h
		    je fin_buscar_letra

		    cmp palabra_real[bx],al
		    jne siguiente

		    mov palabra_oculta[bx],al
		    mov dl,1          ; encontró al menos una vez

		siguiente:
		    inc bx
		    jmp proceso_buscar_letra

		fin_buscar_letra:
		    mov al,dl         ; AL=1 encontró // AL=0 no encontró
		    
		    pop dx
		    pop bx
		    ret
	buscar_letra endp

	verificar_victoria proc
		push bx					;
		lea bx, palabra_oculta 	; Recorrería la palabra oculta para ver si quedan '_', sino ganas pa

		proceso_verificar_victoria:
			cmp byte ptr [bx], '_'
			je no_gano

			cmp byte ptr [bx], 03h
			je gano

			inc bx
			jmp proceso_verificar_victoria

		no_gano:
			mov al, 0
			pop bx
			ret

		gano:
			mov al, 1
			pop bx
			ret
	verificar_victoria endp

	descontar_intentos proc
		dec intentos
		ret
	descontar_intentos endp

	reiniciar_intentos proc
		mov intentos, 6
		ret
	reiniciar_intentos endp

	verificar_derrota proc
		cmp intentos, 0
		je derrota

		mov al, 0 					; En teoría no perdi entonces dejamos así
		jmp fin_verificar_derrota

		derrota:
			mov al, 1 				; Avisaría por AL si perdió o no. Si pierde AL = 1

		fin_verificar_derrota:
			ret
	verificar_derrota endp

	mostrar_ganaste_art proc
		push bx

		lea bx, art_g_l1
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_g_l2
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_g_l3
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_g_l4
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_g_l5
		push bx
		call impresion_03h
		call salto_linea

		pop bx
		ret
	mostrar_ganaste_art endp

	mostrar_salida proc
		call limpiar_pantalla
		ret
	mostrar_salida endp

	mostrar_perdiste_art proc
		push bx

		lea bx, art_p_l1
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_p_l2
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_p_l3
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_p_l4
		push bx
		call impresion_03h
		call salto_linea

		lea bx, art_p_l5
		push bx
		call impresion_03h
		call salto_linea

		pop bx
		ret
	mostrar_perdiste_art endp

	mostrar_derrota proc
		call limpiar_pantalla
		push ax
		push dx
		push bx

		call estado0
		call salto_linea

		lea bx, msj_mostrar_oculta
		push bx
		call impresion_03h

		call salto_linea

		lea bx, palabra_real
		push bx
		call impresion_03h

		call salto_linea

		call mostrar_perdiste_art

		call salto_linea
		call salto_linea
		lea bx, opc_volver_menu
	    push bx
	    call impresion_03h

	    mov ah,08h
	    int 21h

		pop bx
		pop dx
		pop ax
		ret
	mostrar_derrota endp

	mostrar_victoria proc
		push ax
		push dx
		push bx

		mov dh, 7
		mov dl, 0
		call mover_cursor
		lea bx, msj_mostrar_oculta		; pisa el "Ingresa una letra:" con contenido util
		push bx
		call impresion_03h

		lea bx, palabra_real
		push bx
		call impresion_03h

		call salto_linea
		call salto_linea

		call mostrar_ganaste_art

		call salto_linea
		call salto_linea
		lea bx, opc_volver_menu
	    push bx
	    call impresion_03h

	    mov ah,1 				; INT 60 Ruidito fachero facherito si ganás paaa
	    int 60h

	    mov ah,08h				; espera que el jugador presione una tecla antes de volver al menu
	    int 21h

		pop bx
		pop dx
		pop ax
		ret
	mostrar_victoria endp

; ----------------------------------------
; 3) FUNCIONES GRÁFICAS

	mostrar_ahorcado proc
	    cmp intentos,6
	    jne probar5
	    call estado6
	    ret

		probar5:
		    cmp intentos,5
		    jne probar4
		    call estado5
		    ret

		probar4:
		    cmp intentos,4
		    jne probar3
		    call estado4
		    ret

		probar3:
		    cmp intentos,3
		    jne probar2
		    call estado3
		    ret

		probar2:
		    cmp intentos,2
		    jne probar1
		    call estado2
		    ret

		probar1:
		    cmp intentos,1
		    jne mostrar0
		    call estado1
		    ret

		mostrar0:
		    call estado0
		    ret
	mostrar_ahorcado endp

	estado6 proc
	    lea bx,a6_l1
	    push bx

	    lea bx,a6_l2
	    push bx

	    lea bx,a6_l3
	    push bx

	    lea bx,a6_l4
	    push bx

	    lea bx,a6_l5
	    push bx

	    lea bx,a6_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado6 endp

	estado5 proc
	    lea bx,a5_l1
	    push bx

	    lea bx,a5_l2
	    push bx

	    lea bx,a5_l3
	    push bx

	    lea bx,a5_l4
	    push bx

	    lea bx,a5_l5
	    push bx

	    lea bx,a5_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado5 endp

	estado4 proc
	    lea bx,a4_l1
	    push bx

	    lea bx,a4_l2
	    push bx

	    lea bx,a4_l3
	    push bx

	    lea bx,a4_l4
	    push bx

	    lea bx,a4_l5
	    push bx

	    lea bx,a4_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado4 endp

	estado3 proc
	    lea bx,a3_l1
	    push bx

	    lea bx,a3_l2
	    push bx

	    lea bx,a3_l3
	    push bx

	    lea bx,a3_l4
	    push bx

	    lea bx,a3_l5
	    push bx

	    lea bx,a3_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado3 endp

	estado2 proc
	    lea bx,a2_l1
	    push bx

	    lea bx,a2_l2
	    push bx

	    lea bx,a2_l3
	    push bx

	    lea bx,a2_l4
	    push bx

	    lea bx,a2_l5
	    push bx

	    lea bx,a2_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado2 endp

	estado1 proc
	    lea bx,a1_l1
	    push bx

	    lea bx,a1_l2
	    push bx

	    lea bx,a1_l3
	    push bx

	    lea bx,a1_l4
	    push bx

	    lea bx,a1_l5
	    push bx

	    lea bx,a1_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado1 endp

	estado0 proc
	    lea bx,a0_l1
	    push bx

	    lea bx,a0_l2
	    push bx

	    lea bx,a0_l3
	    push bx

	    lea bx,a0_l4
	    push bx

	    lea bx,a0_l5
	    push bx

	    lea bx,a0_l6
	    push bx

	    call imprimir_dibujo
	    ret
	estado0 endp

	imprimir_dibujo proc
	    push bp 								; Función hermosa para no mandar 200 impresiones_03h y salto_linea para cada línea del ahorcado
	    mov bp, sp
	    push bx

	    ; Línea 1
	    mov bx,[bp+14]
	    push bx
	    call impresion_03h
	    call salto_linea

	    ; Línea 2
	    mov bx,[bp+12]
	    push bx
	    call impresion_03h
	    call salto_linea

	    ; Línea 3
	    mov bx,[bp+10]
	    push bx
	    call impresion_03h
	    call salto_linea

	    ; Línea 4
	    mov bx,[bp+8]
	    push bx
	    call impresion_03h
	    call salto_linea

	    ; Línea 5
	    mov bx,[bp+6]
	    push bx
	    call impresion_03h
	    call salto_linea

	    ; Línea 6
	    mov bx,[bp+4]
	    push bx
	    call impresion_03h
	    call salto_linea

	    pop bx
	    pop bp
	    ret 12
	imprimir_dibujo endp

; ----------------------------------------
; 3) FUNCIONES MENÚ PRINCIPAL

	mostrar_menu proc
	    call limpiar_pantalla

	    lea bx, titulo_menu
	    push bx
	    call impresion_03h

	    lea bx, op_jugar
	    push bx
	    call impresion_03h

	    lea bx, op_estadisticas
	    push bx
	    call impresion_03h

	    lea bx, op_creditos
	    push bx
	    call impresion_03h

	    lea bx, op_salir
	    push bx
	    call impresion_03h

	    lea bx, pedir_opcion
	    push bx
	    call impresion_03h

		leer_opcion:
		    mov ah,08h
		    int 21h

		    cmp al,'1'
		    je fin_menu

		    cmp al,'2'
		    je fin_menu

		    cmp al,'3'
		    je fin_menu

		    cmp al,'4'
		    je fin_menu

		    jmp leer_opcion

		fin_menu:
		    ret
	mostrar_menu endp


	mostrar_creditos proc
	    call limpiar_pantalla

	    lea bx, titulo_creditos
	    push bx
	    call impresion_03h

	    lea bx, cred1
	    push bx
	    call impresion_03h

	    lea bx, cred2
	    push bx
	    call impresion_03h

	    lea bx, cred3
	    push bx
	    call impresion_03h

	    lea bx, opc_volver_menu
	    push bx
	    call impresion_03h

	    mov ah,08h
	    int 21h

	    ret
	mostrar_creditos endp

	; imprime un byte como dígito ASCII
	imprimir_numero proc
	    push ax
	    push bx
	    push dx

	    mov ah,0
	    mov bl,10
	    div bl

	    mov bh,ah          ; guardar unidades

	    ; decenas
	    add al,'0'
	    mov dl,al
	    mov ah,02h
	    int 21h

	    ; unidades
	    mov dl,bh
	    add dl,'0'
	    mov ah,02h
	    int 21h

	    pop dx
	    pop bx
	    pop ax
	    ret
	imprimir_numero endp

	mostrar_estadisticas proc
		push bx

		call limpiar_pantalla

		lea bx, titulo_estadisticas
		push bx
		call impresion_03h

		lea bx, msj_partidas
		push bx
		call impresion_03h
		mov al, partidas
		call imprimir_numero
		lea bx, msj_cierre_partidas
		push bx
		call impresion_03h

		lea bx, msj_linea_vacia
		push bx
		call impresion_03h

		lea bx, msj_ganadas
		push bx
		call impresion_03h
		mov al, ganadas
		call imprimir_numero
		lea bx, msj_cierre_ganadas
		push bx
		call impresion_03h

		lea bx, msj_linea_vacia
		push bx
		call impresion_03h

		lea bx, msj_perdidas
		push bx
		call impresion_03h
		mov al, perdidas
		call imprimir_numero
		lea bx, msj_cierre_perdidas
		push bx
		call impresion_03h

		cmp racha, 0
		je sin_racha

		lea bx, msj_linea_vacia
		push bx
		call impresion_03h

		lea bx, msj_racha
		push bx
		call impresion_03h
		mov al, racha
		call imprimir_numero
		lea bx, msj_cierre_racha
		push bx
		call impresion_03h

		sin_racha:
		lea bx, msj_cierre_est
		push bx
		call impresion_03h

		mov ah, 08h
		int 21h

		pop bx
		ret
	mostrar_estadisticas endp

	inc_ganadas proc
		inc partidas
		inc ganadas
		inc racha
		ret
	inc_ganadas endp

	inc_perdidas proc
		inc partidas
		inc perdidas
		mov racha, 0
		ret
	inc_perdidas endp

end