// Importações necessárias para realizar requisições HTTP e trabalhar com JSON
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dados_provider.dart';

// Classe para representar um ID de Cliente
class idCliente {
  int id;
  idCliente(this.id);
}

// Widget que representa a tela de cadastro
class RegistrationScreen extends StatelessWidget {
  // Controladores para os campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Construtor da classe
  RegistrationScreen({Key? key}) : super(key: key);

  // Função assíncrona para enviar dados ao servidor
  Future<void> _enviarDados(BuildContext context) async {
    // URL do servidor de destino
    const String url = "http://localhost/servidor/cadastrar.php";

    // Dados a serem enviados para o servidor
    final Map<String, String> data = {
      'username': _nameController.text,
      'numero': _numeroController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    // Impressão dos dados antes e depois da codificação JSON
    print("Dados antes da codificação JSON: $data");
    final encodedData = json.encode(data);
    print("Dados codificados em JSON: $encodedData");

    try {
      // Requisição HTTP POST para enviar os dados ao servidor
      final response = await http.post(
        Uri.parse(url),
        body: encodedData,
      );

      // Verificação da resposta do servidor
      print("Resposta do servidor: ${response.body}");

      if (response.statusCode == 200) {
        // Dados enviados com sucesso
        print("Dados enviados com sucesso!");
        print("Resposta do servidor: ${response.body}");

        // Decodificar a resposta JSON do servidor
        final responseData = json.decode(response.body);

        if (responseData.containsKey('idCliente')) {
          // ID do usuário retornado pelo servidor
          int idCliente = responseData['idCliente'];
          print('id: ${idCliente}');

          // Atualizar dados globais usando Provider
          Provider.of<DadosProvider>(context, listen: false)
              .setDados("", "", idCliente);

          // Navegar para a tela de login após o cadastro bem-sucedido
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          // Se o servidor não retornou o ID, trata como erro
          _mostrarErroPopUp(context, 'Usuário não cadastrado');
        }
      } else {
        // Tratar erro de código de resposta do servidor
        _mostrarErroPopUp(
            context,
            'Falha ao enviar os dados. Código de resposta: ${response.statusCode}');
      }
    } catch (error) {
      // Tratar erro durante a requisição
      _mostrarErroPopUp(context, 'Erro durante a requisição: $error');
      print("Erro durante a requisição: $error");
    }
  }

  // Função para mostrar um pop-up de erro
  void _mostrarErroPopUp(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Cadastro'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // Widget para construir a interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        // Adiciona um botão de voltar à barra de aplicativos
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Adiciona a lógica para navegar para a tela anterior
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem de logo
            Image.asset(
              'lib/img/logo.jpeg',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 8.0),
            // Título da tela
            Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            // Campos de texto para o nome, e-mail, número e senha
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _numeroController,
              decoration: InputDecoration(
                labelText: 'Celular',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            // Botão para criar a conta
            ElevatedButton(
              onPressed: () {
                // Verifica se os campos estão em branco antes de prosseguir
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                } else {
                  // Envia os dados ao servidor
                  _enviarDados(context);
                }
              },
              child: Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

// Função principal para iniciar o aplicativo
void main() {
  runApp(
    MaterialApp(
      home: RegistrationScreen(),
    ),
  );
}
