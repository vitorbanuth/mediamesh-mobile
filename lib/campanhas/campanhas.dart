import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // 👈 Added for date formatting
import 'package:mediamesh/campanhas/list_campanha.dart';
import 'campanha.dart';

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

  // 👇 Helper functions to format date and handle status
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String getStatus(String? status) {
    if (status == null) return "Inativo";
    return status.toLowerCase() == "active" || status.toLowerCase() == "ativo"
        ? "Ativo"
        : "Inativo";
  }

  Color getStatusColor(String status) {
    return status == "Ativo" ? Colors.green : Colors.red;
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

            // Align(
            //   alignment: Alignment.center,
            //   child: SizedBox(
            //     width: 250,
            //     child: TextFormField(
            //       controller: nomeController,
            //       decoration: const InputDecoration(
            //         labelText: "Nome",
            //         border: OutlineInputBorder(),
            //         focusedBorder: OutlineInputBorder(),
            //       ),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 16),

            // Align(
            //   alignment: Alignment.center,
            //   child: SizedBox(
            //     width: 250,
            //     child: DropdownButtonFormField<String>(
            //       decoration: InputDecoration(
            //         labelText: "Setor",
            //         border: OutlineInputBorder(),
            //         iconColor: Colors.blueAccent,
            //       ),
            //       items: ['Público', 'Privado']
            //           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            //           .toList(),
            //       onChanged: (val) => setState(() => selectedSector = val),

            //       icon: const Icon(
            //         Icons.arrow_drop_down,
            //         color: Colors.blueAccent,
            //       ),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 16),

            // Align(
            //   alignment: Alignment.center,
            //   child: SizedBox(
            //     width: 250,
            //     child: Builder(
            //       builder: (drawerContext) => ElevatedButton(
            //         onPressed: () async {
            //           try {
            //             futureContratantes = filterContratantes(
            //               nomeController.text,
            //               selectedSector,
            //             );

            //             Navigator.of(drawerContext).pop();
            //             setState(() {
            //               selectedSector = null;
            //               nomeController.clear();
            //             });
            //           } catch (e) {
            //             ScaffoldMessenger.of(
            //               drawerContext,
            //             ).showSnackBar(SnackBar(content: Text("Erro: $e")));
            //           }
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.blue,
            //         ),
            //         child: const Text(
            //           "Pesquisar",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Campanhas"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, "/new_contratante").then(
              //   (_) => setState(() {
              //     futureCampanhas = fetchCampanhas();
              //   }),
              // );
            },
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.campaign, size: 28),
                  const Positioned(
                    right: -3,
                    bottom: 22,
                    child: Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

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
              final inicio = formatDate(c.startDate);
              final fim = formatDate(c.endDate);
              final status = getStatus(c.status);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Slidable(
                  key: ValueKey(c.pi),
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
                    leading: const Icon(Icons.campaign),
                    title: Text(c.name),

                    // 👇 Added fields: inicio, fim, and status
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Início: $inicio  •  Fim: $fim"),
                        Text(
                          "Status: $status",
                          style: TextStyle(
                            color: getStatusColor(status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
