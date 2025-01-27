import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JogoDaVelha(),
    );
  }
}

class JogoDaVelha extends StatefulWidget {
  @override
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<List<String>> tabuleiro = List.generate(3, (i) => List.generate(3, (j) => ' '));
  String jogadorAtual = 'X';
  String vencedor = '';

  // Função para marcar o campo
  void _marcarCampo(int linha, int coluna) {
    if (tabuleiro[linha][coluna] == ' ' && vencedor == '') {
      setState(() {
        tabuleiro[linha][coluna] = jogadorAtual;
        if (_verificarVitoria()) {
          vencedor = jogadorAtual;
        } else if (_verificarEmpate()) {
          vencedor = 'Empate';
        } else {
          jogadorAtual = (jogadorAtual == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  // Função para verificar vitória
  bool _verificarVitoria() {
    // Verificando linhas, colunas e diagonais
    for (int i = 0; i < 3; i++) {
      // Linhas
      if (tabuleiro[i][0] == tabuleiro[i][1] && tabuleiro[i][1] == tabuleiro[i][2] && tabuleiro[i][0] != ' ') {
        return true;
      }
      // Colunas
      if (tabuleiro[0][i] == tabuleiro[1][i] && tabuleiro[1][i] == tabuleiro[2][i] && tabuleiro[0][i] != ' ') {
        return true;
      }
    }
    // Diagonais
    if (tabuleiro[0][0] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][2] && tabuleiro[0][0] != ' ') {
      return true;
    }
    if (tabuleiro[0][2] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][0] && tabuleiro[0][2] != ' ') {
      return true;
    }
    return false;
  }

  // Função para verificar empate
  bool _verificarEmpate() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (tabuleiro[i][j] == ' ') {
          return false;
        }
      }
    }
    return true;
  }

  // Função para reiniciar o jogo
  void _reiniciarJogo() {
    setState(() {
      tabuleiro = List.generate(3, (i) => List.generate(3, (j) => ' '));
      jogadorAtual = 'X';
      vencedor = '';
    });
  }

  // Construir o tabuleiro
  Widget _construirTabuleiro() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tabuleiro.map((linha) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: linha.map((celula) {
            int linhaIndex = tabuleiro.indexOf(linha);
            int colunaIndex = linha.indexOf(celula);

            return GestureDetector(
              onTap: () {
                _marcarCampo(linhaIndex, colunaIndex); // Passa a linha e a coluna
              },
              child: Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _obterCorCelula(linhaIndex, colunaIndex),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    celula,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: _obterCorTexto(celula),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // Função para obter a cor da célula (com base na jogada)
  Color _obterCorCelula(int i, int j) {
    if (tabuleiro[i][j] == ' ') {
      return Colors.white; // Células vazias com fundo branco
    }
    return tabuleiro[i][j] == 'X' ? Colors.blue[100]! : Colors.red[100]!; // 'X' em azul e 'O' em vermelho
  }

  // Função para obter a cor do texto (X ou O)
  Color _obterCorTexto(String celula) {
    return celula == 'X' ? Colors.blue : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo da Velha')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _construirTabuleiro(),
            SizedBox(height: 20),
            Text(
              vencedor == '' ? 'Jogador Atual: $jogadorAtual' : (vencedor == 'Empate' ? 'Empate!' : 'Vencedor: $vencedor'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reiniciarJogo,
              child: Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}
