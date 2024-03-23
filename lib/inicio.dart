import 'package:flutter/material.dart';

// Classe que representa a tela de boas-vindas
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Configurando a estrutura da tela
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exibindo uma mensagem de boas-vindas
            Text(
              'Bem Vindo(a)!\n ao Beauty space',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Adicionando um espaçamento vertical
            SizedBox(height: 16),
            // Botão para navegar para a tela de login
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de login
                Navigator.of(context).pushNamed('/login');
              },
              child: Text('Entrar'),
            ),
            // Adicionando um espaçamento vertical
            SizedBox(height: 8),
            // Botão para navegar para a tela de cadastro
            TextButton(
              onPressed: () {
                // Navegar para a tela de cadastro
                Navigator.of(context).pushNamed('/registration');
              },
              child: Text('Fazer cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
