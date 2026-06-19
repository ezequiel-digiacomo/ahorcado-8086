.8086
.model small
.stack 100h
.data
	letra_ingresada   		db ?
.code
	main proc
		extrn iniciar_partida:proc
		extrn mostrar_estado:proc
		extrn leer_caracter:proc
		extrn convertir_mayus:proc
		extrn buscar_letra:proc
		extrn salto_linea:proc
		extrn descontar_intentos:proc
		extrn verificar_victoria:proc
		extrn verificar_derrota:proc
		extrn impresion_03h:proc
		extrn mostrar_derrota:proc
		extrn mostrar_victoria:proc
		extrn mostrar_ahorcado:proc
		extrn mostrar_ganaste_art:proc
		extrn mostrar_perdiste_art:proc
		extrn guardar_letra:proc
		extrn mostrar_menu:proc
		extrn mostrar_creditos:proc
		extrn reiniciar_intentos:proc
		extrn mostrar_salida:proc
		extrn mostrar_estadisticas:proc
		extrn inc_ganadas:proc
		extrn inc_perdidas:proc

		mov ax,@data
		mov ds,ax

		menu_principal:
			call mostrar_menu

			cmp al, '1'
			je jugar

			cmp al, '2'
			je estadisticas

			cmp al, '3'
			je creditos

			cmp al, '4'
			je salir

			jmp menu_principal

		estadisticas:
			call mostrar_estadisticas
			jmp menu_principal

		creditos:
			call mostrar_creditos
			jmp menu_principal

		jugar:
			call reiniciar_intentos
			call iniciar_partida

			ciclo:
			    call mostrar_estado

			    call leer_caracter
			    call convertir_mayus
			    call salto_linea

			    mov letra_ingresada, al		; preservamos la letra antes de que guardar_letra pise AL

			    call guardar_letra			; AL=1 letra nueva / AL=0 ya fue ingresada
			    cmp al, 0
			    je letra_repetida

			    mov al, letra_ingresada		; restauramos la letra para buscar_letra
			    call buscar_letra

			    cmp al,0
			    jne verificar_gano

			    call descontar_intentos

			    call verificar_derrota
			    cmp al,1
			    je perdio

			letra_repetida:
			verificar_gano:
			    call verificar_victoria
			    cmp al,1
			    je gano

			    call salto_linea
			    jmp ciclo

			gano:
	    		call mostrar_estado
	    		call inc_ganadas
	    		call mostrar_victoria
	    		jmp menu_principal

			perdio:
				call inc_perdidas
				call mostrar_derrota
				jmp menu_principal

		salir:
			call mostrar_salida
			mov ax, 4c00h
			int 21h
	main endp
end