import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:mediamesh/campanhas/list_campanha.dart';
import 'campanha.dart';
import 'list_campanha_pontos.dart';

class Campanhas extends StatefulWidget {
  const Campanhas({super.key});

  @override
  State<Campanhas> createState() => _CampanhasState();
}

class _CampanhasState extends State<Campanhas> {
  late Future<List<Campanha>> futureCampanhas;

  Future<List<Campanha>> fetchCampanhas() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/campaigns'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        final List<dynamic> jsonList = decoded["data"];
        return jsonList.map((json) => Campanha.fromJson(json)).toList();
      }

      if (decoded is List) {
        return decoded.map((json) => Campanha.fromJson(json)).toList();
      }

      throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao carregar contratantes [${response.statusCode}]: ${response.body}',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    futureCampanhas = fetchCampanhas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade200,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [TextSpan(text: "Filtrar Campanhas")],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Campanhas"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_alt_outlined, size: 28),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Campanha>>(
        future: futureCampanhas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum contratante cadastrado."));
          }

          final campanhas = snapshot.data!;
          return ListView.builder(
            itemCount: campanhas.length,
            itemBuilder: (context, index) {
              final c = campanhas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Slidable(
                  key: ValueKey(c.pi),
                  endActionPane: ActionPane(
                    extentRatio: 0.70,

                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CampanhaPontos(cmpgn: c),
                            ),
                          );
                        },
                        backgroundColor: Colors.blue,
                        icon: Icons.location_on_rounded,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListCampanha(campanha: c),
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
                    iconColor: Colors.green.shade700,
                    leading: Icon(Icons.campaign),
                    title: Text(c.name),
                    // subtitle: Text("${c.contact.name} • ${c.contact.email}"),
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
