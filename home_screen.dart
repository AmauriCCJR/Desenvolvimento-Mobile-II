import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cidade = TextEditingController();
  final TextEditingController _graus = TextEditingController();
  final TextEditingController _tempo = TextEditingController();
  late String _img;

  void exibirDados() async {
    http.Response resposta = await http.get(
      Uri.parse(
        "http://api.weatherapi.com/v1/current.json?key=a8d689b0344c45ba96701033261308&q=${_cidade.text}&aqi=no&lang=pt",
      ),
    );

    Map<String, dynamic> dados = jsonDecode(resposta.body);
    _preencherCampos(dados);
  }

  void _preencherCampos(Map<String, dynamic> dados) {
    setState(() {
      _graus.text = dados['current']['temp_c'].toString();
      _tempo.text = dados['current']['condition']['text'].toString();
      _img = dados['current']['condition']['icon'];
    });
  }

  //===========================Códiguin==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API via Weather", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cidade,
                  decoration: InputDecoration(
                    label: Text("Digite o nome da cidade"),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  exibirDados();
                },
                child: Text("Buscar"),
              ),
            ],
          ),

          SizedBox(height: 40),

          TextField(
            controller: _graus,
            decoration: InputDecoration(label: Text("Graus celcius")),
          ),
          SizedBox(height: 20),

          TextField(
            controller: _tempo,
            decoration: InputDecoration(label: Text("Estado do tempo")),
          ),
          SizedBox(height: 20),

          Image.network(_img),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
