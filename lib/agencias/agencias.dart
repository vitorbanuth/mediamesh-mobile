import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mediamesh/agencias/list_agencia.dart';
import 'agencia_model.dart';

class Agencias extends StatefulWidget {
  const Agencias({super.key});

  @override
  State<Agencias> createState() => _AgenciasState();
}

class _AgenciasState extends State<Agencias> {
  late Future<List<Agencia>> futureAgencias;

  @override
  void initState() {
    super.initState();
    futureAgencias = fetchAgencias();
  }

  Future<List<Agencia>> fetchAgencias() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/agencies'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        return (decoded["data"] as List)
            .map((json) => Agencia.fromJson(json))
            .toList();
      }
      if (decoded is List) {
        return decoded.map((json) => Agencia.fromJson(json)).toList();
      }
      throw Exception("Formato inesperado: $decoded");
    } else {
      throw Exception("Erro ao carregar agencias: ${response.body}");
    }
  }

  final TextEditingController nomeController = TextEditingController();
  String? selectedSector;

  final Map<String, String> sectorMap = {
    "Privado": "PRIVATE",
    "Público": "PUBLIC",
  };

  Future<List<Agencia>> filterAgencias(
    String? nomeText,
    String? sectorText,
  ) async {
    Map<String, String> queryParams = {};

    if (nomeText != null && nomeText.trim().isNotEmpty) {
      queryParams['filter[_name]'] = 'like';
      queryParams['filter[name]'] = nomeText.trim();
    }

    final sectorValue = (sectorText != null && sectorText.isNotEmpty)
        ? (sectorMap[sectorText] ?? sectorText)
        : null;

    if (sectorValue != null) {
      queryParams['filter[_sector]'] = 'like';
      queryParams['filter[sector]'] = sectorValue;
    }

    final uri = Uri.https(
      'sinestro.mediamesh.com.br',
      '/api/agencies',
      queryParams,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        return (decoded["data"] as List)
            .map((json) => Agencia.fromJson(json))
            .toList();
      }
      if (decoded is List) {
        return decoded.map((json) => Agencia.fromJson(json)).toList();
      }
      throw Exception("Formato inesperado: $decoded");
    } else {
      throw Exception("Erro ao carregar agencias: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade200,
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Filtrar Agências",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: Builder(
                  builder: (drawerContext) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureAgencias = filterAgencias(
                          nomeController.text,
                          selectedSector,
                        );
                      });
                      Navigator.of(drawerContext).pop();
                      nomeController.clear();
                      selectedSector = null;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Pesquisar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Agências"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/new_agencia").then(
                (_) => setState(() {
                  futureAgencias = fetchAgencias();
                }),
              );
            },
            icon: const Icon(Icons.add_business),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Agencia>>(
        future: futureAgencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma agência encontrada."));
          }

          final agencias = snapshot.data!;
          return ListView.builder(
            itemCount: agencias.length,
            itemBuilder: (context, index) {
              final a = agencias[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Slidable(
                  key: ValueKey(a.taxId),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListAgencia(agencia: a),
                            ),
                          );
                        },
                        backgroundColor: Colors.deepPurple,
                        icon: Icons.remove_red_eye,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(a.name),
                    subtitle: Text("${a.contact.name} • ${a.contact.email}"),
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
