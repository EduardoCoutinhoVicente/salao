// dados_provider.dart
import 'package:flutter/material.dart';
 
class DadosProvider extends ChangeNotifier {
  String dado1 = "";
  String dado2 = "";
  int dado3 =0;

  void setDados(String novoDado1, String novoDado2, int novoDado3) {
    dado1 = novoDado1;
    dado2 = novoDado2;
    dado3 = novoDado3;

    // Notifique os ouvintes (widgets) sobre a mudança nos dados
    notifyListeners();
  }
}

class Agendamento {
  final String servico;
  final String preco;
  final String dia;
  final String hora;

  Agendamento({
    required this.servico,
    required this.preco,
    required this.dia,
    required this.hora,
  });
}
