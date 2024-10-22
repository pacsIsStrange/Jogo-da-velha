      ORG 0000
0000| MOV R3, #00h	; R3 vai ser usado como variável auxiliar pra guardar o 'input' do usuário no keypad
0002| MOV R1, #14h	; R1 ? um "ponteiro" que diz qual célula do tabuleiro está sendo verificada
0004| MOV R2, #45h	; R2 serve como um iterador pra percorrer todo o tabuleiro
0006| MOV R7, #11H; R7 vai ser usado pra "pintar" o tabuleiro de acordo com o jogador
       
      reiniciaTabuleiro: ; Função que reinicia o tabuleiro para seu estado inicial
0008| 	MOV @R1, #00h
000A| 	INC R1
000B| 	DJNZ R2, reiniciaTabuleiro
       
      desenhaTabuleiro:	; desenha as "bordas" do tabuleiro
000D| 	MOV 14h, #0FFh
0010| 	MOV 15h, #0FFh
0013| 	MOV 16h, #0FFh
0016| 	MOV 17h, #0FFh
0019| 	MOV 18h, #0FFh
001C| 	MOV 24h, #0FFh
001F| 	MOV 28h, #0FFh
0022| 	MOV 34h, #0FFh
0025| 	MOV 38h, #0FFh
0028| 	MOV 44h, #0FFh
002B| 	MOV 48h, #0FFh
002E| 	MOV 54h, #0FFh
0031| 	MOV 55h, #0FFh
0034| 	MOV 56h, #0FFh
0037| 	MOV 57h, #0FFh
003A| 	MOV 58h, #0FFh
       
       
      main:
      	;ACALL lcd_init
      mainLoop:
003D| 	ACALL leituraTeclado
003F| 	JNB F0, mainLoop
0042| 	ACALL executaJogada
0044| 	SJMP mainLoop
      	
      	
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
0046| 	CLR F0
0048| 	MOV R6, #03h	; R6 vai guardar qual tecla foi pressionada
       
      ;	scan linha 1
004A| 	SETB P0.0	
004C| 	CLR P0.1	
004E| 	CALL scanCol
0050| 	JB F0, fim	; se a tecla foi encontrada, retorna da fun??o
      	
      ;	scan linha 2
0053| 	SETB P0.1	
0055| 	CLR P0.2	
0057| 	CALL scanCol
0059| 	JB F0, fim	; se a tecla foi encontrada, retorna da fun??o
      	
      ;	scan linha 3
005C| 	SETB P0.2	
005E| 	CLR P0.3	
0060| 	CALL scanCol
       
      fim:
0062| 	RET
       
      scanCol:
0063| 	JNB P0.4, achouTecla	; se a coluna 0 est? limpa, achou a tecla na coluna 0
0066| 	INC R6	; move a busca para a pr?xima coluna
0067| 	JNB P0.5, achouTecla	; se a coluna 1 est? limpa, achou a tecla na coluna 1
006A| 	INC R6	; move a busca para a pr?xima coluna
006B| 	JNB P0.6, achouTecla	; se a coluna 2 est? limpa, achou a tecla na coluna 2
006E| 	INC R6	; move a busca para a pr?xima coluna
006F| 	RET	; retorna da subrotina sem ter encontrado a tecla
       
      achouTecla:
0070| 	SETB F0	; se achou tecla, 'seta' o F0 (como se fosse bool)
0072| 	RET
       
      executaJogada: ; Função que executa a jogada pretendida pelo jogador
0073| 	MOV A, R6
0074| 	CJNE A, #03, teclaNove
0077| 	MOV R0, #47h
0079| 	SJMP pintaCelula
       
      teclaNove: ; Função que executa a jogada na tecla 9
007B| 	CJNE A, #04, teclaOito
007E| 	MOV R0, #46h
0080| 	SJMP pintaCelula
       
      teclaOito: ; Função que executa a jogada na tecla 8
0082| 	CJNE A, #05, teclaSete
0085| 	MOV R0, #45h
0087| 	SJMP pintaCelula
       
      teclaSete: ; Função que executa a jogada na tecla 7
0089| 	CJNE A, #06, teclaSeis
008C| 	MOV R0, #37h
008E| 	SJMP pintaCelula
       
      teclaSeis: ; Função que executa a jogada na tecla 6
0090| 	CJNE A, #07, teclaCinco
0093| 	MOV R0, #36h
0095| 	SJMP pintaCelula
       
      teclaCinco: ; Função que executa a jogada na tecla 5
0097| 	CJNE A, #08, teclaQuatro
009A| 	MOV R0, #35h
009C| 	SJMP pintaCelula
       
      teclaQuatro: ; Função que executa a jogada na tecla 4
009E| 	CJNE A, #09, teclaTres
00A1| 	MOV R0, #027h
00A3| 	SJMP pintaCelula
       
      teclaTres: ; Função que executa a jogada na tecla 3
00A5| 	CJNE A, #0Ah, teclaDois
00A8| 	MOV R0, #26h
00AA| 	SJMP pintaCelula
       
      teclaDois: ; Função que executa a jogada na tecla 2
00AC| 	CJNE A, #0Bh, teclaUm
00AF| 	MOV R0, #25h
00B1| 	SJMP pintaCelula
       
      teclaUm: ; Função que executa a jogada na tecla 1
00B3| 	CJNE A, #0Ch, fim		
00B6| 	MOV R0, #25h
       
      pintaCelula: ; Função que demarca a jogada do jogador na posição do tabuleiro
00B8| 	MOV A, @R0
00B9| 	CJNE A, #0, fim
00BC| 	MOV A, R7
00BD| 	MOV @R0, A
00BE| 	ACALL trocaJogador
00C0| 	RET
       
      trocaJogador: ; Função que alterna o turno de cada jogador
00C1| 	MOV A, R7
00C2| 	CJNE A, #11h, trocaParaJogador1  ; Se não for 11h, troque para jogador 1
00C5| 	MOV R7, #22h		; Se R7 = 11h, troca pra jogador 2
00C7| 	SJMP fim
       
      trocaParaJogador1:
00C9| 	MOV R7, #11h		; Se R7 = 22h, troca pra jogador 1
00CB| 	RET
       
      procuraVitoria:
00CC| 	MOV R4, #00h
00CE| 	MOV R0, #25h
00D0| 	MOV A, @R0
00D1| 	CJNE A, #0, verificaLinha0
00D4| 	SJMP verificaLinha1
       
      verificaLinha0:
00D6| 	MOV R1, #26h
00D8| 	MOV B, @R1
00DA| 	CJNE A, B, verificaLinha1
00DD| 	INC R1
00DE| 	MOV B, @R1
00E0| 	CJNE A, B, verificaLinha1
00E3| 	LJMP verificaVencedor
       
      verificaLinha1:	
00E6| 	MOV R0, #35h
00E8| 	MOV A, @R0
00E9| 	CJNE A, #0, verificaLinha2
00EC| 	LJMP fim
       
      verificaLinha2:
00EF| 	MOV R1, #36h
00F1| 	MOV B, @R1
00F3| 	CJNE A, B, verificaColuna0
00F6| 	INC R1
00F7| 	MOV B, @R1
00F9| 	CJNE A, B, verificaColuna0
00FC| 	LJMP verificaVencedor
      	
00FF| 	MOV R0, #45h
0101| 	MOV A, @R0
0102| 	CJNE A, #0, verificaColuna0
0105| 	LJMP fim
       
      verificaColuna0:
0108| 	MOV R0, #25h
010A| 	MOV A, @R0
010B| 	CJNE A, #0, verificaColuna1
010E| 	LJMP fim
       
      verificaColuna1:
0111| 	MOV R1, #35h
0113| 	MOV B, @R1
0115| 	CJNE A, B, verificaColuna2
0118| 	MOV R1, #45h
011A| 	MOV B, @R1
011C| 	CJNE A, B, verificaColuna2
011F| 	LJMP verificaVencedor
      	
      verificaColuna2:
0122| 	MOV R0, #26h
0124| 	MOV A, @R0
0125| 	CJNE A, #0, verificaColuna3
0128| 	LJMP fim
       
      verificaColuna3:
012B| 	MOV R1, #36h
012D| 	MOV B, @R1
012F| 	CJNE A, B, verificaColuna4
0132| 	MOV R1, #46h
0134| 	MOV B, @R1
0136| 	CJNE A, B, verificaColuna4
0139| 	LJMP verificaVencedor
       
      verificaColuna4:
013C| 	MOV R0, #27h
013E| 	MOV A, @R0
013F| 	CJNE A, #0, verificaColuna5
0142| 	LJMP fim
       
      verificaColuna5:
0145| 	MOV R1, #37h
0147| 	MOV B, @R1
0149| 	CJNE A, B, verificaDiagoNal0
014C| 	MOV R1, #47h
014E| 	MOV B, @R1
0150| 	CJNE A, B, verificaDiagonal0
0153| 	LJMP verificaVencedor
       
      verificaDiagonal0:
0156| 	MOV R0, #25h
0158| 	MOV A, @R0
0159| 	CJNE A, #0, verificaDiagonal1
015C| 	LJMP fim
       
      verificaDiagonal1:
015F| 	MOV R1, #36h
0161| 	MOV B, @R1
0163| 	CJNE A, B, verificaDiagonal2
0166| 	MOV R1, #47h
0168| 	MOV B, @R1
016A| 	CJNE A, B, verificaDiagonal2
016D| 	LJMP verificaVencedor
       
      verificaDiagonal2:
0170| 	MOV R0, #27h
0172| 	MOV A, @R0
0173| 	CJNE A, #0, verificaDiagonal3
0176| 	LJMP fim
       
      verificaDiagonal3:
0179| 	MOV R1, #36h
017B| 	MOV B, @R1
017D| 	CJNE A, B, atalhoFim
0180| 	MOV R1, #45h
0182| 	MOV B, @R1
0184| 	CJNE A, B, atalhoFim
       
      verificaVencedor:
0187| 	MOV R4, A
0188| 	MOV R5, #01
      	
       
      atalhoFim:
018A| 	RET
