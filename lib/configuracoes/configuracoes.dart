import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Configuracoes extends StatelessWidget {
  const Configuracoes({super.key});

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuracoes")),
      body: const Center(
        child: Text("Tela de configuracoes!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
