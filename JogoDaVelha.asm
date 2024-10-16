MOV R0, #00h	; R0 vai ser usado como variável auxiliar pra guardar o 'input' do usuário no keypad
MOV R1, #14h	; R1 � um "ponteiro" que diz qual célula do tabuleiro está sendo verificada
MOV R2, #45h	; R2 serve como um iterador pra percorrer todo o tabuleiro
MOV R7, #11H; R7 vai ser usado pra "pintar" o tabuleiro de acordo com o jogador

reiniciaTabuleiro: //Função que reinicia o tabuleiro para seu estado inicial
	MOV @R1, #00h
	INC R1
	DJNZ R2, reiniciaTabuleiro

desenhaTabuleiro:	; desenha as "bordas" do tabuleiro
	MOV 14h, #0FFh
	MOV 15h, #0FFh
	MOV 16h, #0FFh
	MOV 17h, #0FFh
	MOV 18h, #0FFh
	MOV 24h, #0FFh
	MOV 28h, #0FFh
	MOV 34h, #0FFh
	MOV 38h, #0FFh
	MOV 44h, #0FFh
	MOV 48h, #0FFh
	MOV 54h, #0FFh
	MOV 55h, #0FFh
	MOV 56h, #0FFh
	MOV 57h, #0FFh
	MOV 58h, #0FFh


main:
	;ACALL lcd_init
mainLoop:
	ACALL leituraTeclado
	JNB F0, mainLoop
	
;	+----+----+----+
;	| 11 | 10 |  9 |	linha3
;	+----+----+----+
;	|  8 |  7 |  6 |	linha2
;	+----+----|----+
;	|  5 |  4 |  3 |	linha1
;	+----+----+----+
;	|  2 |  1 |  0 |	linha0
;	+----+----+----+
;	 col2 col1 col0

leituraTeclado:
	MOV R6, #00h	; R6 vai guardar qual tecla foi pressionada

;	scan linha 0
	MOV P0, #0FFh
	CLR P0.0	
	CALL scanCol
	JB F0, fim	; se a tecla foi encontrada, retorna da fun��o
	
;	scan linha 1
	SETB P0.0	
	CLR P0.1	
	CALL scanCol
	JB F0, fim	; se a tecla foi encontrada, retorna da fun��o
	
;	scan linha 2
	SETB P0.1	
	CLR P0.2	
	CALL scanCol
	JB F0, fim	; se a tecla foi encontrada, retorna da fun��o
	
;	scan linha 3
	SETB P0.2	
	CLR P0.3	
	CALL scanCol
	JB F0, fim	; se a tecla foi encontrada, retorna da fun��o
	
fim:
	RET

scanCol:
	JNB P0.4, achouTecla	; se a coluna 0 est� limpa, achou a tecla na coluna 0
	INC R6	; move a busca para a pr�xima coluna
	JNB P0.4, achouTecla	; se a coluna 1 est� limpa, achou a tecla na coluna 1
	INC R6	; move a busca para a pr�xima coluna
	JNB P0.4, achouTecla	; se a coluna 2 est� limpa, achou a tecla na coluna 2
	INC R6	; move a busca para a pr�xima coluna
	RET	; retorna da subrotina sem ter encontrado a tecla

achouTecla:
	SETB F0	; se achou tecla, 'seta' o F0 (como se fosse bool)
	RET

executaJogada: //Função que executa a jogada pretendida pelo jogador
	MOV A, R6
	CJNE A, #03, teclaNove
	MOV DPTR, #47H
	SJMP pintaCelula

teclaNove: //Função que executa a jogada na tecla 9
	CJNE A, #04, teclaOito
	MOV DPTR, #46h
	SJMP pintaCelula

teclaOito: //Função que executa a jogada na tecla 8
	CJNE A, #05, teclaSete
	MOV DPTR, #45h
	SJMP pintaCelula

teclaSete: //Função que executa a jogada na tecla 7
	CJNE A, #06, teclaSeis
	MOV DPTR, #37h
	SJMP pintaCelula

teclaSeis: //Função que executa a jogada na tecla 6
	CJNE A, #07, teclaCinco
	MOV DPTR, #36h
	SJMP pintaCelula

teclaCinco: //Função que executa a jogada na tecla 5
	CJNE A, #08, teclaQuatro
	MOV DPTR, #35h
	SJMP pintaCelula

teclaQuatro: //Função que executa a jogada na tecla 4
	CJNE A, #09, teclaTres
	MOV DPTR, #046h
	SJMP pintaCelula

teclaTres: //Função que executa a jogada na tecla 3
	CJNE A, #10, teclaDois
	MOV DPTR, #27h
	SJMP pintaCelula

teclaDois: //Função que executa a jogada na tecla 2
	CJNE A, #11, teclaUm
	MOV DPTR, #26h
	SJMP pintaCelula

teclaUm: //Função que executa a jogada na tecla 1
	CJNE A, #12, fim		
	MOV DPTR, #25h

pintaCelula: //Função que demarca a jogada do jogador na posição do tabuleiro
	MOVX A, @DPTR
	CJNE A, #00, fim
	MOV A, R7
	MOVX @DPTR, A
	ACALL trocaJogador

trocaJogador: //Função que alterna o turno de cada jogador
	MOV A, R7
	CJNE A, #11h, verificaJogador	; se R7 não é "11" verifica se é "22"
	MOV R7, #22h		; se R7 = "11" troca pra vez do jogador 2
	SJMP fim

verificaJogador: //Função que alterna o turno de cada jogador
	CJNE A, #22h, fim		; se o R7 não for "22" encerra a função, pois já está correto
	MOV R7, #11h		; se R7 = "22"  troca pra vez do jogador 1

lcd_init:

;	CLR RS		; clear RS - indicates that instructions are being sent to the module

; function set	
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear	
					; function set sent for first time - tells module to go into 4-bit mode
; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.

;	SETB EN		; |
;	CLR EN		; | negative edge on E
					; same function set high nibble sent a second time

	SETB P1.7		; low nibble set (only P1.7 needed to be changed)

;	SETB EN		; |
;	CLR EN		; | negative edge on E
				; function set low nibble sent
	CALL delay		; wait for BF to clear


; entry mode set
; set to increment with no shift
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear


; display on/off control
; the display is turned on, the cursor is turned on and blinking is turned on
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET

sendCharacter:
;	SETB RS  		; setb RS - indicates that data is being sent to module
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

;	SETB EN			; |
;	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

;	SETB EN			; |
;	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endere o da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
;	CLR RS	
	SETB P1.7		    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

;	SETB EN			; |
;	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

;	SETB EN			; |
;	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET

clearDisplay:
;	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET

;Retorna o cursor para primeira posi  o sem limpar o display
retornaCursor:
;	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

;	SETB EN		; |
;	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


delay:
	MOV R7, #50
	DJNZ R7, $
	RET




