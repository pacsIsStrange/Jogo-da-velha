Relatório 2 do projeto de Arquitetura de Computadores

Lucas Roberto Boccia dos Santos (22.123.012-1)
Pedro Alexandre Custódio Silva (22.123.049-3)

Projeto: Jogo da Velha

----------------------------------------------------------------------------------------------------------------

Na segunda semana de desenvolvimento do projeto, demos continuidade ao desenvolvimento da parte lógica do jogo da velha, já implementado as funções de executar jogada (que executa no tabuleiro a jogada pretendida pelo jogador), as funções que executam a jogada pretendida para cada tecla (das teclas 1 a 9), a função que altera o valor da posição da respectiva tecla de 0 para o símbolo apropriado (nomeada pintaCelula), a função que alterna o turno entre os dois jogadores e iniciamos o desenvolvimento da parte do LCD, no entanto, ainda está só em fase inicial e não totalmente funcional. A explicação do código está nos comentários.
Para a próxima semana, já teremos o projeto concluído com a parte do LCDs e do display de messagens.


Explicação do funcionamento da máquina:

 

A região demarcada pelas bordas FF é o tabuleiro do jogo da velha. Os jogadores utilizarão o keypad (teclado numérico de 1 a 9 na parte inferior) para definir seus lances, alternando um lance para cada jogador. As regras de vitória, derrota e empate seguem as mesmas do clássico jogo da velha. Caso algum jogador vença, uma sequência de LEDs será mostrada no display de LEDs na parte inferior ao tabuleiro. Por fim, uma mensagem será exibida no display de mensagens (parte inferior direita) dizendo qual jogador venceu a partida. Em caso de empate, será exibida uma sequência diferente de LEDs e uma mensagem diferente.

![image](https://github.com/user-attachments/assets/00382ad1-e807-4ac2-9e80-66214bcf4475)
