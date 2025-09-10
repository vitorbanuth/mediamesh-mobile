import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Arquivos extends StatelessWidget {
  const Arquivos({super.key});

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Arquivos")),
      body: const Center(
        child: Text("Tela de arquivos!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
