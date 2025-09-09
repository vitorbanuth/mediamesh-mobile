import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pop.dart';

class Pontos extends StatefulWidget {
  const Pontos({super.key});

  @override
  State<Pontos> createState() => _PontosState();
}

class _PontosState extends State<Pontos> {
  late Future<List<Ponto>> pontos;

  Future<List<Ponto>> fetchPontos() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/pops'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%229E4DQBPR%22%2C%22apiVersion%22%3A%22993fda5c%22%2C%22account%22%3A%7B%22taxId%22%3A%2210276433000128%22%2C%22alias%22%3A%22devs%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22name%22%3A%22Ksmz%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%7D%7D.ovxaACdIZDF7tU3Z%2BgPfGTJXdKP6QWWieeyi%2FbD5nms',
      },
    );

    // print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Pega a lista dentro de "data"
      final List<dynamic> data = jsonResponse["data"] ?? [];
      return data.map((json) => Ponto.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao carregar pontos: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    pontos = fetchPontos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pontos")),
      body: FutureBuilder<List<Ponto>>(
        future: pontos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final lista = snapshot.data!;
            if (lista.isEmpty) {
              return const Center(child: Text("Nenhum ponto encontrado"));
            }
            return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final ponto = lista[index];
                return ListTile(
                  title: Text(ponto.name),
                  subtitle: Text(ponto.address),
                );
              },
            );
          } else {
            return const Center(child: Text("Nenhum ponto encontrado"));
          }
        },
      ),
    );
  }
}
