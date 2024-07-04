# README

# Damas (Checkers)

![Ruby Version](https://img.shields.io/badge/Ruby-3.1.2-red.svg)
![Rails Version](https://img.shields.io/badge/Rails-7.1.3.4-orange.svg)


Projeto de API de jogo de damas com regras oficiais de movimentação e capturas de peças.

* ### Para Jogadores:
  * É possível jogar sem cadastro. 
  * Comporta até dois jogadores divididos pela cor da peça de cada um
  * Regras oficiais
  

  
## Requisitos

Certifique-se de ter as seguintes dependências instaladas:

- Ruby 3.1.2;
- Ruby on Rails 7.1.3.4.

## Instalação

1. Clone este repositório para o seu ambiente local:

```bash
git clone git@github.com:thony-vieira/checkers.git
cd checkers
```

2. Instale as gems necessárias:

```bash
bundle install
```

3. Inicie o servidor Rails:

```bash
rails server
```

4. Teste usando Postman usando seu servidor local:

```bash
http://localhost:3000/api/v1/games
```

5. Para jogar por comando de console:

```bash
game = TextApi.new
```

6. Instruçoes do jogo:
   Peças brancas jogam primeiro. Os movimentos são alternados e realizaados por meio de comandos no console que indiquem a posição atual da peça e a posição final no tabuleiro , exemplo: D2 to C3.
   Para capturar uma peça o jogador deverá indicar a célula de destino pulando a célula da peça capturada , exemplo: C3 to D5, a peça inimiga capturada sumirá do tabuleiro.
   As capturas podem ser feitas sempre na diagonal, tanto para frente quanto para trás. Havendo mais de uma peça disponível para se capturar, é obrigatório realizar o movimento de captura das peças disponíveis.
   Caso uma das pedras chegue na última linha do lado adversário, a peça será promovida a "Dama", tendo sua movimentação expandida para todo o tabuleiro, movimentando-se da mesma maneira, exemplo: B0 to G5.
   A dama pode capturar uma peça e optar por não estacionar na celula imediatamente atrás dela, podendo avançar as celulas se o movimento for válido.
   O movimento é valido se ele sempre avançar na direção das peças adversárias, se for sempre em diagonal e uma celula de distância nas celulas adjacentes frontais. Damas se movem tanto para frente, quanto para trás, porém sempre em diagonal.

