import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Import the Contratante model
import 'contratante_model.dart'; // <-- create this file with the class above

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
      Uri.parse('https://sinestro.mediamesh.com.br/api/campaingns'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer {{TOKEN}}', // troque pelo token válido
      },
    );

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");  

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Contratante.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar contratantes: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contratantes"),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<List<Contratante>>(
        future: futureContratantes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum contratante cadastrado."),
            );
          }

          final contratantes = snapshot.data!;
          return ListView.builder(
            itemCount: contratantes.length,
            itemBuilder: (context, index) {
              final c = contratantes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(c.name),
                  subtitle: Text("${c.contact.name} • ${c.contact.email}"),
                  trailing: Text(c.sector),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(c.name),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CNPJ: ${c.taxId}"),
                            Text("Endereço: ${c.address}"),
                            Text("CEP: ${c.cep}"),
                            const Divider(),
                            Text("Contato: ${c.contact.name}"),
                            Text("Email: ${c.contact.email}"),
                            Text("Telefone: ${c.contact.phone}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Fechar"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/new_contratante")
              .then((_) => setState(() {
                    futureContratantes = fetchContratantes();
                  }));
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
