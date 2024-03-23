import 'package:flutter/material.dart';
import 'dados_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class Agendamento {
  final String servico;
  final int preco;
  final String dia;
  final String hora;

  Agendamento({required this.servico, required this.preco,required this.dia,required this.hora,});
  
  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      servico: json['servico'],
      preco: json['preco'],
      dia: json['dia'],
      hora: json['hora'],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String fotoUsuario = "lib/img/perfil.jpg";
  List<Agendamento> agendamentos = [];
  //late TextEditingController _id ;
  String oi3 ="";

  @override
  Widget build(BuildContext context) {
    DadosProvider dadosProvider = Provider.of<DadosProvider>(context);
    oi3 = dadosProvider.dado3.toString();

return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Cliente'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(fotoUsuario),
            ),
            SizedBox(height: 16.0),
            Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/inicio');
              },
              child: Text('Logout'),
            ),
 if (agendamentos.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: agendamentos.length,
                  itemBuilder: (context, index) {
                    Agendamento agendamento = agendamentos[index];

                    return ListTile(
                      title: Text('Serviço: ${agendamento.servico}'),
                      subtitle: Text(
                          'Preço: ${agendamento.preco}\nDia: ${agendamento.dia}\nHora: ${agendamento.hora}'
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

@override
void initState() {
  super.initState();
  //_id = TextEditingController();

  Future.delayed(Duration.zero, () {
    _getAgendamentos(context, oi3);
  });
}

  Future<void> _getAgendamentos(BuildContext context, String id) async {
    const String url = "http://localhost/servidor/agendamentos.php";
    print("oi3: $oi3");
    final Map<String, String> data = {
      'id': oi3,
    };

    final encodedData = json.encode(data);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: encodedData,
      );
      print("Resposta do servidor: ${response.body}");
      if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('agendamentos')) {
        List<Agendamento> agendamentos = List<Agendamento>.from(
          responseData['agendamentos'].map(
            (agendamento) {
              return Agendamento(
                servico: agendamento['servico'],
                preco: agendamento['preco'],
                dia: agendamento['dia'],
                hora: agendamento['hora'],
              );
            },
          ),
        );
        setState(() {
          this.agendamentos = agendamentos;
        });
      }
    }  else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text(
                  'Falha ao obter os agendamentos. Código de resposta: ${response.statusCode}'),
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
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Erro durante a requisição: $error'),
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
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ProfileScreen(),
    ),
  );
}