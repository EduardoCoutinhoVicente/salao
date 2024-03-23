import 'package:flutter/material.dart';
import 'telaPrincipal.dart';
import 'login.dart';
import 'perfil.dart';
import 'inicio.dart';
import 'agendmento.dart';
import 'package:provider/provider.dart';
import 'telaRegistro.dart';
import 'dados_provider.dart'; //importa o arquivo dados_provider.dart

void main() {
  runApp(
    // Utilizando o Provider para gerenciar o estado global
    ChangeNotifierProvider(
      create: (context) => DadosProvider(),
      child: MyApp(),
    ),
  );
}

// Classe que representa os argumentos passados para a tela
class Argumentos {
  String servico;
  String dia;
  String hora;
  String preco;

  Argumentos({this.servico = '', this.dia = '', this.hora = '', this.preco = ''});
}

// Classe principal que configura as rotas da aplicação
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/inicio',
      routes: {
        // Rota para a tela de boas-vindas
        '/inicio': (context) => WelcomeScreen(),

        // Rota para a tela de login
        '/login': (context) => MeuAplicativo(),

        // Rota para a tela principal
        '/home': (context) => HomeScreen(),

        // Rota para a tela de perfil
        '/profile': (context) => ProfileScreen(),

        // Rota para a tela de agendamento
        '/appointment': (context) => AppointmentScreen(),

        // Rota para a tela de registro
        '/registration': (context) => RegistrationScreen(),
      },
    );
  }
}
