import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dados_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Classe que representa um serviço disponível
class Servico {
  String nome;
  String preco;

  Servico(this.nome, this.preco);
}

// Tela principal da aplicação
class HomeScreen extends StatelessWidget {
  // Lista de serviços disponíveis
  final List<Servico> servicos = [
    Servico('Tratamento Facial', '100'),
    Servico('Corte de Cabelo', '80'),
    Servico('Maquiagem', '190'),
    Servico('Manicure', '45'),
    Servico('Pedicure', '30'),
  ];

  // Lista de horários disponíveis
  final List<String> times = [
    '09:00',
    '11:00 ',
    '14:00 ',
    '16:00 ',
    '18:00 ',
  ];

  @override
  Widget build(BuildContext context) {
    // Obtenha a instância do provedor de dados usando o Provider
    DadosProvider dadosProvider = Provider.of<DadosProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faça seu agendamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega de volta para a tela anterior
            Navigator.of(context).pop();
          },
        ),
        // Adiciona um ícone no canto superior direito
        actions: [
          IconButton(
            icon: Icon(MdiIcons.accountCircle), // Ícone de perfil
            onPressed: () {
              // Navega para a tela de perfil
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha um serviço:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: servicos.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('${servicos[index].nome} - R\$${servicos[index].preco}'),
                      subtitle: Text('Horários disponíveis: ${times.join(", ")} '),
                      onTap: () {
                        int idCliente = dadosProvider.dado3;
                        print('idCliente: $idCliente');
                        
                        // Atualiza os dados globais usando o Provider
                        Provider.of<DadosProvider>(context, listen: false)
                            .setDados(servicos[index].nome, servicos[index].preco, idCliente);
                        
                        // Navega para a tela de agendamento
                        Navigator.pushNamed(context, '/appointment');
                      },
                    ),
                  );
                },
              ),
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
      home: HomeScreen(), // Define a tela inicial como HomeScreen
    ),
  );
}
