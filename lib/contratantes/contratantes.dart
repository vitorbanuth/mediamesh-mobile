import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mediamesh/contratantes/list_contratante.dart';

import 'contratante_model.dart';

class Contratantes extends StatefulWidget {
  const Contratantes({super.key});

  @override
  State<Contratantes> createState() => _ContratantesState();
}

class _ContratantesState extends State<Contratantes> {
  late Future<List<Contratante>> futureContratantes;

  @override
  void initState() {
    super.initState();
    futureContratantes = fetchContratantes();
  }

  Future<List<Contratante>> fetchContratantes() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/advertisers'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%229E4DQBPR%22%2C%22apiVersion%22%3A%22993fda5c%22%2C%22account%22%3A%7B%22taxId%22%3A%2210276433000128%22%2C%22alias%22%3A%22devs%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22name%22%3A%22Ksmz%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%7D%7D.ovxaACdIZDF7tU3Z%2BgPfGTJXdKP6QWWieeyi%2FbD5nms',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        final List<dynamic> jsonList = decoded["data"];
        return jsonList.map((json) => Contratante.fromJson(json)).toList();
      }

      if (decoded is List) {
        return decoded.map((json) => Contratante.fromJson(json)).toList();
      }

      throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao carregar contratantes [${response.statusCode}]: ${response.body}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contratantes"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/new_contratante").then(
                (_) => setState(() {
                  futureContratantes = fetchContratantes();
                }),
              );
            },
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.work, size: 28),
                  const Positioned(
                    right: -5,
                    bottom: 18,
                    child: Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.filter_alt_outlined, size: 30), // Maleta
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Contratante>>(
        future: futureContratantes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum contratante cadastrado."));
          }

          final contratantes = snapshot.data!;
          return ListView.builder(
            itemCount: contratantes.length,
            itemBuilder: (context, index) {
              final c = contratantes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Slidable(
                  key: ValueKey(c.taxId),
                  endActionPane: ActionPane(
                    extentRatio: 0.70,

                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {},
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListContratante(contratante: c),
                              ),
                            );
                        },
                        backgroundColor: Colors.deepPurple,
                        icon: Icons.remove_red_eye,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    iconColor: Colors.blue.shade900,
                    leading: Icon(Icons.business_center),
                    title: Text(c.name),
                    subtitle: Text("${c.contact.name} • ${c.contact.email}"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
