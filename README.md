# Relatório final do projeto de Arquitetura de Computadores
Lucas Roberto Boccia dos Santos (22.123.012-1)

Pedro Alexandre Custódio Silva (22.123.049-3)
### Projeto: Jogo da Velha

# Introdução
O projeto de Arquitetura de Computadores consiste no desenvolvimento de uma clássica versão do jogo da velha em Assembly para a arquitetura do Intel 8051, feito para ser rodado por meio da plataforma Edsim51.
O jogo funciona a partir do tabela de Data Memory do Edsim51, onde uma área demarcada na tabela é criada para ser o tabuleiro do jogo, a partir da função desenha tabuleiro.
Para jogar, basta selecionar qual célula deseja realizar sua jogada por meio do teclado virtual do Edsim51. As regras do jogo seguem as mesmas do clássico Jogo da Velha.

# Metodologia
### Recursos Necessários:
* Plataforma Edsim51 (preferencialmente em sua versão mais atualizada)

# Métodos

O projeto foi desenvolvido ao longo do semestre em duas etapas.

### Etapa 1 - Programação do jogo da velha

A primeira etapa de desenvolvimento consistiu na programação da lógica do jogo da velha na lingaugem Assembly.
Para isso, utilizamos a seguinte lógica:

R1 - O registrador R1 funciona como um "ponteiro" que diz qual célula do tabuleiro está sendo verificada
R2 - O registrador R2 serve como um iterador pra percorrer todo o tabuleiro
R4 - O registrador R4 guarda qual dos dois jogadores venceu a partida
R5 - O registrador R5 é um registrador booleano que altera seu valor para 1 quando algum jogador vence o jogo ou quando ocorre empate
R6 - O registrador R6 é utilizado como variável auxiliar pra guardar o 'input' do usuário no keypad
R7 - O registrador R7 vai ser usado pra "pintar" o tabuleiro de acordo com o jogador]
P0 - "Reseta" o teclado para o estado inicial
P1 - Mapeamento de Hardware do 8051

O jogo funciona em um loop que, a cada jogada, procura se algum jogador venceu a partida, caso nenhuma condição de vitória tenha sido alcançada, o jogo prossegue para o turno do próximo jogador, e assim sucessivamente, também havendo funções que "pintam" as células do tabuleiro e que realizam a leitura do teclado.
Quando algum jogador vence a partida, o programa transforma o valor do registrador R5 em 1 e guarda no registrador R4 o jogador que venceu a partida, e segue para a implementação da etapa 2.

O código a seguir representa o funcionamento da etapa 1, os comentários explicam de maneira mais aprofundada o que cada linha de código faz e/ou representa:

### Início do programa e tabuleiro
```
ORG 0000
MOV R3, #00h	; R3 vai ser usado como variável auxiliar pra guardar o 'input' do usuário no keypad
MOV R1, #14h	; R1 e um "ponteiro" que diz qual célula do tabuleiro está sendo verificada
MOV R2, #45h	; R2 serve como um iterador pra percorrer todo o tabuleiro
MOV R7, #11H	; R7 vai ser usado pra "pintar" o tabuleiro de acordo com o jogador
       
reiniciaTabuleiro: ; Função que reinicia o tabuleiro para seu estado inicial
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
```
### Main Loop
```       
mainLoop:
 	ACALL leituraTeclado
 	JNB F0, mainLoop
 	ACALL executaJogada
	ACALL procuraVitoria
	MOV A, R5
	CJNE A, #01, mainLoop
	ACALL START
 	SJMP mainLoop

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

```
### Leitura do teclado e execução de jogadas

```
leituraTeclado:
 	CLR F0
	MOV P0, #11111111b
 	MOV R6, #03h	; R6 vai guardar qual tecla foi pressionada

      ;	scan linha 1
 	SETB P0.0
 	CLR P0.1
 	CALL scanCol
 	JB F0, fim	; se a tecla foi encontrada, retorna da fun??o

      ;	scan linha 2
	SETB P0.1
 	CLR P0.2
 	CALL scanCol
 	JB F0, fim	; se a tecla foi encontrada, retorna da fun??o

      ;	scan linha 3
 	SETB P0.2

 	CLR P0.3
 	CALL scanCol

fim:
 	RET

scanCol:
 	JNB P0.4, achouTecla	; se a coluna 0 esta limpa, achou a tecla na coluna 0
 	INC R6	; move a busca para a proxima coluna
 	JNB P0.5, achouTecla	; se a coluna 1 esta limpa, achou a tecla na coluna 1
 	INC R6	; move a busca para a proxima coluna
 	JNB P0.6, achouTecla	; se a coluna 2 esta limpa, achou a tecla na coluna 2
 	INC R6	; move a busca para a proxima coluna
 	RET	; retorna da subrotina sem ter encontrado a tecla

achouTecla:
 	SETB F0	; se achou tecla, 'seta' o F0 (como se fosse bool)
 	RET

executaJogada:	; Função que executa a jogada pretendida pelo jogador
 	MOV A, R6
 	CJNE A, #03, teclaNove	; pula para a proxima se a tecla pressionada NAO foi 9
 	MOV R0, #47h
 	SJMP pintaCelula

teclaNove:	; repete a verificacao acima para a telca 8
 	CJNE A, #04, teclaOito	; pula para a proxima se a tecla pressionada NAO foi 8
 	MOV R0, #46h
 	SJMP pintaCelula

teclaOito:	; repete a verificacao acima para a tecla 7
 	CJNE A, #05, teclaSete	; pula para a proxima se a tecla pressionada NAO foi 7
 	MOV R0, #45h
 	SJMP pintaCelula
       
teclaSete:	; repete a verificacao acima para a tecla 6
 	CJNE A, #06, teclaSeis	; pula para a proxima se a tecla presionada NAO foi 6
 	MOV R0, #37h
 	SJMP pintaCelula
       
teclaSeis:	; [...] para a tecla 5
 	CJNE A, #07, teclaCinco	; [...] NAO foi 5
 	MOV R0, #36h
 	SJMP pintaCelula
       
teclaCinco:	; [...] para a tecla 4
 	CJNE A, #08, teclaQuatro;[...] NAO foi 4
 	MOV R0, #35h
 	SJMP pintaCelula
       
teclaQuatro:	;[...] para a tecla 3
 	CJNE A, #09, teclaTres	;[...] NAO foi 3
 	MOV R0, #027h
 	SJMP pintaCelula
       
teclaTres:	;[...] para a tecla 2
 	CJNE A, #0Ah, teclaDois	;[...] NAO foi 2
 	MOV R0, #26h
 	SJMP pintaCelula
       
teclaDois:	;[...] para a tecla 1
 	CJNE A, #0Bh, teclaUm	;[...] NAO foi 1
 	MOV R0, #25h
 	SJMP pintaCelula

```
### "Pintar as celulas e trocar o jogador
```
pintaCelula:	; pinta o endereco da memoria correspondente ao input do jogador no teclado
 	MOV A, @R0	; move o valor que esta guardado na posicao correspondente ao input do jogador
 	CJNE A, #0, fim	; se o valor nao for 0 (ou seja, a posicao ja foi preenchida), retorna da funcao para receber outro input do usuario
 	MOV A, R7	; move o numero do jogador de quem e a vez para o acumulador
 	MOV @R0, A	; pinta a celula com o numero do jogador
 	ACALL trocaJogador	; depois de pintar a celula, troca a vez do jogador
 	RET
       
trocaJogador:	; funcao que vai alternar entre o numero dos jogadores para "trocar a vez"
 	MOV A, R7	; R7 aqui esta guardando o numero do jogador que fez a ultima jogada (11 ou 22)
 	CJNE A, #11h, trocaParaJogador1	; se o ultimo a jogar foi o jogador 2, troca para a vez do jogador 1
 	MOV R7, #22h	; se o ultimo a jogar nao foi o jogador 2, troca para a vez dele
 	SJMP fim
       
trocaParaJogador1:
	MOV R7, #11h	; define o jogador da vez como o jogador 1
 	RET
```
### Procurando a vitória

```
       
procuraVitoria:
; ao final da execução dessa subrotina, R4 guardará o numero do jogador vencedor, caso haja um vencedor
; além disso, R5 guardará "1" se houver um vencedor
 	MOV R4, #00h

; inicio da verificacao para a linha [25 26 27]
 	MOV R0, #25h
 	MOV A, @R0	; guarda o valor armazenado no endereco 25 em A
 	CJNE A, #0, verificaLinha0	; se o endereco nao esta vazio, continua a verificacao da linha
 	SJMP verificaLinha1	; se o endereco esta vazio, pula para a verificacao da proxima linha [35 36 37]
       
; etapa "0" da verificacao de linhas
verificaLinha0:	
 	MOV R1, #26h
 	MOV B, @R1	; guarda o valor armazenado no endereco 26 em B
 	CJNE A, B, verificaLinha1	; se A e B nao sao iguais, pula para a verificacao da proxima linha
 	INC R1
 	MOV B, @R1	; guarda o valor armazenado no endereco 27 em B
 	CJNE A, B, verificaLinha1	; se A e B nao sao iguais, pula para a verificacao da proxima linha
 	LJMP verificaVencedor	; se A e B sao iguais em ambas as comparacoes, houve vitoria
       
; etapa "1" da verificacao de linhas
verificaLinha1:	; inicio da verificacao para a linha [35 36 37]
 	MOV R0, #35h
 	MOV A, @R0	; guarda o valor armazenado no endereco 35 em A
 	CJNE A, #0, verificaLinha2	; se o endereco nao esta vazio, continua a verificaacao da linha
 	SJMP verificaLinha3	; se o endereco esta vazio, pula para a verificacao da proxima linha

; etapa "2" da verificacao de linhas
verificaLinha2:
 	MOV R1, #36h
 	MOV B, @R1	; guarda o valor armazenado no endereco 36 em B
 	CJNE A, B, verificaLinha3	; se A e B nao sao iguais, pula para a verificacao da proxima linha
 	INC R1
 	MOV B, @R1	; guarda o valor armazenado no endereco 37 em B
 	CJNE A, B, verificaLinha3	; se A e B nao sao iguais, pula para a verificacao da proxima linha
 	LJMP verificaVencedor	; se A e B sao iguais em ambas as comparacoes, houve vitoria

; etapa "3" da verificacao de linhas
verificaLinha3:	; inicio da verificacao para a linha [45 46 47]
 	MOV R0, #45h
 	MOV A, @R0	; guarda o valor armazenado no endereco 45 em A
 	CJNE A, #0, verificaLinha4	; se o endereco nao esta vazio, continua a verificacao da linha
 	SJMP verificaColuna0	; se o endereco esta vazio, pula para a verificacao da primeira coluna [25|35|45]

; etapa "4" da verificacao de linhas
verificaLinha4:
	MOV R1, #46h
	MOV B, @R1	; guarda o valor armazenado no endereco 46 em B
	CJNE A, B, verificaColuna0	; se A e B nao sao iguais, pula para a verificacao da primeira coluna
	INC R1
	MOV B, @R1	; guarda o valor armazenado no endereco 47 em B
	CJNE A, B, verificaColuna0	; se A e B nao sao iguais, pula para a verificacao da primeira coluna
	LJMP verificaVencedor	; se A e B sao iguas em ambas as comparacoes, houve vitoria
       
; etapa "0" da verificacao de colunas
verificaColuna0:	; inicio da verificacao da coluna [25|35|45]
 	MOV R0, #25h
 	MOV A, @R0	; guarda o valor armazenado no endereco 25 em A
 	CJNE A, #0, verificaColuna1	; se o endereco nao esta vazio, continua a verificacao da coluna
 	SJMP verificaColuna2	; se o endereco esta vazio, pula para a verificacao da proxima coluna
       
; etapa "1" da verificacao de colunas
verificaColuna1:
 	MOV R1, #35h
 	MOV B, @R1	; guarda o valor armazenado no endereco 35 em B
 	CJNE A, B, verificaColuna2	; se A e B nao sao iguais, pula para a verificacao da proxima coluna
 	MOV R1, #45h
 	MOV B, @R1	; guarda o valor armazenado no endereco 45 em B
 	CJNE A, B, verificaColuna2	; se A e B nao sao iguais, pula para a verificacao da proxima coluna
 	LJMP verificaVencedor
      	
; etapa "0" da verificacao de colunas
verificaColuna2:	; inicio da verificacao da coluna [26|36|46]
 	MOV R0, #26h
 	MOV A, @R0	; guarda o valor armazenado no endereco 26 em A
 	CJNE A, #0, verificaColuna3 ; se o endereco nao esta vazio, continua a verificacao da coluna
 	SJMP verificaColuna4	; se o endereco esta vazio, pula para a verificacao da proxima coluna
       
; etapa "0" da verificacao de colunas
verificaColuna3:
 	MOV R1, #36h
 	MOV B, @R1
 	CJNE A, B, verificaColuna4
 	MOV R1, #46h
 	MOV B, @R1
 	CJNE A, B, verificaColuna4
 	LJMP verificaVencedor
       
; etapa "0" da verificacao de colunas
verificaColuna4:
 	MOV R0, #27h
 	MOV A, @R0
 	CJNE A, #0, verificaColuna5
 	LJMP fim
       
; etapa "0" da verificacao de colunas
verificaColuna5:
 	MOV R1, #37h
 	MOV B, @R1
 	CJNE A, B, verificaDiagoNal0
 	MOV R1, #47h
 	MOV B, @R1
 	CJNE A, B, verificaDiagonal0
 	LJMP verificaVencedor
       
verificaDiagonal0:
 	MOV R0, #25h
 	MOV A, @R0
 	CJNE A, #0, verificaDiagonal1
 	SJMP verificaDiagonal2
       
      verificaDiagonal1:
 	MOV R1, #36h
 	MOV B, @R1
 	CJNE A, B, verificaDiagonal2
 	MOV R1, #47h
 	MOV B, @R1
 	CJNE A, B, verificaDiagonal2
 	LJMP verificaVencedor
       
verificaDiagonal2:
 	MOV R0, #27h
 	MOV A, @R0
 	CJNE A, #0, verificaDiagonal3
 	LJMP fim
       
verificaDiagonal3:
 	MOV R1, #36h
 	MOV B, @R1
 	CJNE A, B, atalhoFim
 	MOV R1, #45h
 	MOV B, @R1
 	CJNE A, B, atalhoFim
       
verificaVencedor:
 	MOV R4, A
 	MOV R5, #01
      	       
atalhoFim:
 	RET
```

# Etapa 2 - LCD e LEDs

A segunda etapa consiste na implementação dos recursos de LCD e LEDs do Edsim51, que utiliza os códigos disponibilizados em aula para "printar" uma mensagem no LCD e duas funções que determinam qual mensagem será printada.
As duas opções de mensagem são:
"Vitória - Jogador 1"
"Vitória - Jogador 2"
Para tal, assim que uma vitória é encontrada pelo loop da Etapa 1, modificando o valor do registrador R5 para 1, inicia-se a sequência Start no código que exibe no display LCD a mensagem "Vitória", e um laço condicional verifica o valor do registrador R4 atrás de qual jogador venceu a partida. O valor encontrado na verificação determina qual função do programa será utilizada para printar o restante da mensagem.

O código a seguir representa o funcionamento da etapa 1, os comentários explicam de maneira mais aprofundada o que cada linha de código faz e/ou representa:

```
; --- Mapeamento de Hardware (8051) ---
    RS      equ     P1.3    ;Reg Select ligado em P1.3
    EN      equ     P1.2    ;Enable ligado em P1.2

START:
	acall lcd_init
	mov A, #04h
	ACALL posicionaCursor 
	MOV A, #'V'
	ACALL sendCharacter	; send data in A to LCD module
	MOV A, #'i'
	ACALL sendCharacter	; send data in A to LCD module
	MOV A, #'t'
	ACALL sendCharacter	; send data in A to LCD module
	MOV A, #'o'
	ACALL sendCharacter	
	MOV A, #'r'
	ACALL sendCharacter	
	MOV A, #'i'
	ACALL sendCharacter
	MOV A, #'a'
	ACALL sendCharacter
	MOV A, #' '
	ACALL sendCharacter		
	MOV A, R4
	ACALL displayValue		
	ACALL retornaCursor
	JMP $




; initialise the display
; see instruction set for details
lcd_init:

	CLR RS		; clear RS - indicates that instructions are being sent to the module

; function set	
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear	
					; function set sent for first time - tells module to go into 4-bit mode
; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.

	SETB EN		; |
	CLR EN		; | negative edge on E
					; same function set high nibble sent a second time

	SETB P1.7		; low nibble set (only P1.7 needed to be changed)

	SETB EN		; |
	CLR EN		; | negative edge on E
				; function set low nibble sent
	CALL delay		; wait for BF to clear


; entry mode set
; set to increment with no shift
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear


; display on/off control
; the display is turned on, the cursor is turned on and blinking is turned on
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


sendCharacter:
	SETB RS  		; setb RS - indicates that data is being sent to module
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endere�o da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	         ; clear RS - indicates that instruction is being sent to module
	SETB P1.4	    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	RET


;Retorna o cursor para primeira posi��o sem limpar o display
retornaCursor:
	CLR RS	      ; clear RS - indicates that instruction is being sent to module
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


;Limpa o display
clearDisplay:
	CLR RS	      ; clear RS - indicates that instruction is being sent to module
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


delay:
	MOV R6, #50
	DJNZ R6, $
	RET

displayValue:
    ; Assume que o valor em A é 11 ou 22
    CJNE R4, #11h, show22   ; Se A não for 11, vai mostrar 22
    ; Para 11:
    ; Convertendo e enviando o primeiro dígito (1)
    MOV A, #1
    ADD A, #30h           ; Converter para ASCII
    ACALL sendCharacter

    ; Convertendo e enviando o segundo dígito (1)
    MOV A, #1
    ADD A, #30h           ; Converter para ASCII
    ACALL sendCharacter
    RET

show22:
    ; Para 22:
    ; Convertendo e enviando o primeiro dígito (2)
    MOV A, #2
    ADD A, #30h           ; Converter para ASCII
    ACALL sendCharacter

    ; Convertendo e enviando o segundo dígito (2)
    MOV A, #2
    ADD A, #30h           ; Converter para ASCII
    ACALL sendCharacter
    RET
```

# Fotos da plataforma e do funcionamento do programa

![image](https://github.com/user-attachments/assets/d8935281-3bad-4b20-8e76-a981ae028b48)

![image](https://github.com/user-attachments/assets/82ae0f4c-98d8-42d6-878a-85380d63648f)

![image](https://github.com/user-attachments/assets/5a8be17a-2214-499a-95df-fbd9d085d1cb) (Versão um pouco mais antiga)

# Fluxograma

```mermaid
graph TD;
    reiniciaTabuleiro-->desenhaTabuleiro;
    desenhaTabuleiro-->mainlLoop;
    mainLoop-->leituraTeclado;
    mainLoop-->executaJogada;
    mainLoop-->procuraVitoria;
    mainLoop-->START;
    leituraTeclado-->scanCol;
    scanCol-->achouTecla;
    executaJogada-->teclaNove;
    teclaNove-->teclaOito;
    teclaNove-->pintaCelula;
    teclaOito-->teclaSete;
    teclaOito-->pintaCelula;
    teclaSete-->teclaSeis;
    teclaSete-->pintaCelula;
    teclaSeis-->teclaCinco;
    teclaSeis-->pintaCelula;
    teclaCinco-->teclaQuatro;
    teclaCinco-->pintaCelula;
    teclaQuatro-->teclaTres;
    teclaQuatro-->pintaCelula;
    teclaTres-->teclaDois;
    teclaTres-->pintaCelula;
    teclaDois-->teclaUm;
    teclaDois-->pintaCelula;
    pintaCelula-->trocaJogador;
    trocaJogador-->trocaParaJogador1;
    procuraVitoria-->verificaLinha0;
    procuraVitoria-->verificaLinha1;
    verificaLinha0-->verificaLinha1;
    verificaLInha0-->verificaVencedor;
    verificaLinha1-->verificaLinha2;
    verificaLinha1-->verificaLinha3;
    verificaLinha2-->verificaLinha3;
    verificaLinha2-->verificaVencedor;
    verificaLinha3-->verificaLinha4;
    verificaLinha3-->verificaColuna0;
    verificaLinha4-->verificaColuna0;
    verificaLinha4-->verificaVencedor;
    verificaColuna0-->verificaColuna1;
    verificaColuna0-->verificaColuna2;
    verificaColuna1-->verificaColuna2;
    verificaColuna1-->verificaVencedor;
    verificaColuna2-->verificaColuna3;
    verificaColuna2-->verificaColuna4;
    verificaColuna3-->verificaColuna4;
    verificaColuna3-->verificaVencedor;
    verificaColuna4-->verificaColuna5;
    verificaColuna5-->verificaDiagonal0;
    verificaColuna5-->verificaVencedor;
    verificaDiagonal0-->verificaDiagonal1;
    verificaDiagonal0-->verificaDigaonal2;
    verificaDiagonal1-->verificaDiagonal2;
    verificaDiagonal1-->verificaVencedor;
    verificaDiagonal2-->verificaDiagonal3;
    verificaDiagonal3-->atalhoFim;
    START-->lcd_init;
    START-->posicionaCursor;
    START-->sendCharacter;
    START-->displayValue;
    START-->retornaCursor;
    lcd_init-->delay;
    sendCharacter-->delay;
    posicionaCursor-->delay;
    retornaCursor-->delay;
    displayValue-->sendCharacter;
    displayValue-->show22;
    show22-->sendCharacter;
```

# Conclusão
A proposta foi atendida com sucesso. Completamos a implementação do jogo da velha utilizando os recursos disponíveis no Edsim51 e desenvolvemos nossas habilidades nas matérias trabalhadas ao longo do semestre na disciplina de Arquitetura de Computadores, com auxílio dos excelentes professores da matéria.



