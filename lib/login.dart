import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dados_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login Usuário",
      home: MeuAplicativo(),
    );
  }
}

class MeuAplicativo extends StatelessWidget {
  // Controladores para os campos de entrada
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _login = TextEditingController();

  MeuAplicativo({Key? key}) : super(key: key);

  // Função assíncrona para enviar os dados de login para o servidor
  Future<void> _enviarDados(BuildContext context) async {
    // URL do servidor de destino
    const String url = "http://localhost/servidor/processa.php";

    // Dados a serem enviados para o servidor
    final Map<String, String> data = {
      'username': _login.text,
      'password': _senha.text,
    };

    // Imprime os dados antes e depois da codificação JSON
    print("Dados antes da codificação JSON: $data");
    final encodedData = json.encode(data);
    print("Dados codificados em JSON: $encodedData");

    try {
      // Requisição HTTP POST para enviar os dados ao servidor
      final response = await http.post(
        Uri.parse(url),
        body: encodedData,
      );

      // Verifica se a resposta do servidor foi bem-sucedida
      if (response.statusCode == 200) {
        print("Dados enviados com sucesso!");
        print("Resposta do servidor: ${response.body}");

        // Decodifica a resposta JSON do servidor
        final responseData = json.decode(response.body);

        // Verifica se a resposta contém o ID do Cliente
        if (responseData.containsKey('idCliente')) {
          int idCliente = responseData['idCliente'];

          // Atualiza os dados do Provider com o ID do Cliente
          Provider.of<DadosProvider>(context, listen: false)
              .setDados("", "", idCliente);
          print('id: ${idCliente}');

          // Navega para a tela principal após o login bem-sucedido
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Mostra um pop-up de erro se o usuário não for encontrado ou as credenciais forem inválidas
          _mostrarErroPopUp(context, 'Usuário não encontrado ou credenciais inválidas.');
        }
      } else {
        // Mostra um pop-up de erro se a resposta do servidor não foi bem-sucedida
        _mostrarErroPopUp(context, 'Falha ao enviar os dados. Código de resposta: ${response.statusCode}');
      }
    } catch (error) {
      // Mostra um pop-up de erro se ocorrer um erro durante a requisição
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
          title: Text('Erro de Login'),
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

  // Constrói a interface da tela de login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login de Usuário'),
        // Adiciona um botão de voltar à barra de aplicativos
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Adiciona a lógica para navegar para a tela anterior
            Navigator.of(context).pop();
          },
        ),
                // Adiciona um ícone no canto superior direito
        actions: [
          IconButton(
            icon: Icon(MdiIcons.accountCircle), // Ícone de perfil
            onPressed: () {
              // Navega para a tela de perfil
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adiciona a imagem do logo
            Image.asset(
              'lib/img/logo.jpeg',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 8.0),
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            // Campo de texto para o email
            TextField(
              controller: _login,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12.0),
            // Campo de texto para a senha
            TextField(
              controller: _senha,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            // Botão para enviar os dados
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () {
                // Verifica se os campos estão em branco antes de prosseguir
                if (_login.text.isEmpty || _senha.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                } else {
                  // Envia os dados de login para o servidor
                  _enviarDados(context);
                }
              },
              child: const Text(
                'Entrar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            // Botão para navegar para a tela de registro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: Text(
                'Não tem uma conta? Registre-se aqui.',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
