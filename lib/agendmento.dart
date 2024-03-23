import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
//import 'main.dart';
import 'dados_provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
  
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _formattedSelectedDate; // Nova variável para armazenar a data formatada
  //TextEditingController _idLoginController = TextEditingController();
  TextEditingController _servicoController = TextEditingController();
  TextEditingController _horaController = TextEditingController();
  TextEditingController _diaController = TextEditingController();
  TextEditingController _precoController = TextEditingController();

  String oi2 =" ";
  int oi3 =0;
  final List<String> times = [
    '09:00',
    '11:00',
    '14:00',
    '16:00',
    '18:00',
  ];

  @override
  Widget build(BuildContext context) {
    DadosProvider dadosProvider = Provider.of<DadosProvider>(context);
      String oi = dadosProvider.dado1;
      
      oi2 = dadosProvider.dado2;
      oi3 = dadosProvider.dado3;
      print('id agebdamento: ${dadosProvider.dado3}');
      print('_dateController: ${ dadosProvider.dado2}');
      //print('_dateController: ${oi2}');
      _servicoController.text = oi;


      _precoController.text=  oi2;
      

      print('_dateController: ${_precoController.text}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento para ${dadosProvider.dado1}'),
    
      
        
        actions: [
          IconButton(
            icon: Icon(MdiIcons.accountCircle),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
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
              'Escolha uma data:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 11, 29),
              lastDay: DateTime.utc(2023, 12, 31),
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                    // Formatando a data selecionada com informações de hora
                    _formattedSelectedDate =
                        DateFormat('dd-MM-yyyy').format(selectedDay);
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Escolha um horário:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: times.map((time) {
                return GestureDetector(
                  onTap: () {
                    // Exibir diálogo de confirmação
                    _showConfirmationDialog(_formattedSelectedDate, time);
                    _diaController.text = _formattedSelectedDate ?? '';
                      _horaController.text = time;

                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedDay != null
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
    
  }
  


   // Função para exibir o diálogo de confirmação
  void _showConfirmationDialog(String? formattedDate, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação de Agendamento'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Data e Hora: ${_formattedSelectedDate ?? 'N/A'} às $time'),
              SizedBox(height: 16.0),
              Text('Deseja confirmar o agendamento?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Lógica para confirmar o agendamento
                _enviarDados(context);
              
                Navigator.pop(context);
              },
              child: Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para cancelar o agendamento
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  } 
  
   // Função assíncrona para enviar dados para o servidor
  Future<void> _enviarDados(BuildContext context) async {
    // URL do servidor de destino
    const String url = "http://localhost/servidor/agendar.php";
    String numeroString = oi3.toString();
    
    // Dados a serem enviados para o servidor
    final Map<String, String> data = {
      'servico': _servicoController.text,
      'data': _diaController.text,
      'hora': _horaController.text,
      'preco': _precoController.text,
      'idLogin': numeroString,
    };
    
      print('_servicoController: ${_servicoController.text}');
      print('_dateController: ${_diaController.text}');
      print('_horaController: ${_horaController.text}');
      print('idLogin: $numeroString');
      
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
      if (response.statusCode == 200) {
        
        // Dados enviados com sucesso
        print("Dados enviados com sucesso!");
        print("Resposta do servidor: ${response.body}");

        //verifica se o usuario foi encontrado
        if(response.body.trim() == '["Agendamento marcado"]'){
        Navigator.pushReplacementNamed(context, '/profile');
        } else{
           // Mostrar o pop-up ao pressionar o botão
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Erro no agendamento'),
                  content: Text('Usuário não encontrado ou credenciais inválidas.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Fechar o pop-up
                        Navigator.of(context).pop();
                      },
                      child: Text('Fechar'),
                    ),
                  ],
                );
              },
            );
      
        }

      } else {
        // Falha ao enviar os dados
        print("Falha ao enviar os dados. Código de resposta: ${response.statusCode}");
      }
    } catch (error) {
      // Tratamento de erro durante a requisição
      print("Erro durante a requisição: $error");
    }
  }

  // Função para confirmar o agendamento
  void _confirmAppointment() {
    // Adicione a lógica para confirmar o agendamento
    // Pode incluir o salvamento em um banco de dados, envio de notificações, etc.
    
    print('Agendamento confirmado!');
  }
}
void main() {
  runApp(
    MaterialApp(
      home: AppointmentScreen(),
    ),
  );
}
