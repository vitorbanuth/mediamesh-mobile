import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mediamesh/pontos/edit_pops.dart';
import 'package:mediamesh/pontos/new_pops.dart';
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

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse["data"] ?? [];
      return data.map((json) => Ponto.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao carregar pontos: ${response.statusCode}");
    }
  }

  Future<void> deletePonto(String unique) async {
    final response = await http.delete(
      Uri.parse('https://sinestro.mediamesh.com.br/api/pops/$unique'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%229E4DQBPR%22%2C%22apiVersion%22%3A%22993fda5c%22%2C%22account%22%3A%7B%22taxId%22%3A%2210276433000128%22%2C%22alias%22%3A%22devs%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22name%22%3A%22Ksmz%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%7D%7D.ovxaACdIZDF7tU3Z%2BgPfGTJXdKP6QWWieeyi%2FbD5nms',
      },
    );

    if (response.statusCode == 200) {
      print("✅ Ponto deletado com sucesso");
    } else {
      throw Exception("Falha ao deletar ponto: ${response.statusCode}");
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
      appBar: AppBar(
        title: const Text("Pontos"),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt_sharp),
            iconSize: 32,
            onPressed: () async {
              final pontoCriado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewPops()),
              );

              if (pontoCriado != null) {
                print("entrei no if");
                setState(() {
                  pontos = fetchPontos();
                });
              } else {
                print("entrei no else ");
              }
            },
          ),

          IconButton(
            onPressed: () {
              // TODO FILTER BTN
            },
            icon: const Icon(Icons.filter_alt_outlined),
            iconSize: 32,
          ),
        ],
      ),
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
            return ListView.separated(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final ponto = lista[index];
                return Slidable(
                  key: ValueKey(ponto.id),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final pontoAtualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPops(ponto: ponto),
                            ),
                          );

                          if (pontoAtualizado == true) {
                            setState(() {
                              pontos = fetchPontos();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          try {
                            await deletePonto(
                              ponto.unique,
                            ); // deleta no backend
                            setState(() {
                              pontos =
                                  fetchPontos(); // atualiza a lista igual no create
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("✅ Ponto deletado com sucesso"),
                              ),
                            );
                          } catch (e) {
                            print("Erro ao deletar: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Erro ao deletar ponto: $e"),
                              ),
                            );
                          }
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(ponto.name),
                    subtitle: Text(ponto.reference),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          } else {
            return const Center(child: Text("Nenhum ponto encontrado"));
          }
        },
      ),
    );
  }
}
