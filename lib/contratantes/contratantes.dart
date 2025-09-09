import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Contratantes extends StatelessWidget {
  const Contratantes({super.key});

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contratantes")),
      body: const Center(
        child: Text("Tela de contratantes!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
