import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Agencias extends StatelessWidget {
  const Agencias({super.key});

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agencias")),
      body: const Center(
        child: Text("Tela de agencias!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
