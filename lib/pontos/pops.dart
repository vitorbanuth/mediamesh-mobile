import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mediamesh/pontos/list_pop.dart';
import 'package:mediamesh/pontos/edit_pops.dart';
import 'package:mediamesh/pontos/new_pops.dart';
import 'pop.dart';

class Pontos extends StatefulWidget {
  const Pontos({super.key});

  @override
  State<Pontos> createState() => _PontosState();
}

class _PontosState extends State<Pontos> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedType;
  String? selectedOrientation;
  String? selectedMaterial;
  String? selectedFacePosition;

  final Map<String, String> kindMap = {
    "Outdoor": "OUTDOOR",
    "Indoor": "INDOOR",
    "Elevador": "ELEVATOR",
  };

  final Map<String, String> materialMap = {
    "Estático": "PAPER",
    "Digital": "DIGITAL",
    "Vinil": "VINYL",
  };

  final Map<String, String> orientationMap = {
    "Vertical": "PORTRAIT",
    "Horizontal": "LANDSCAPE",
    "Neutro": "NEUTRAL",
  };

  final Map<String, String> facePositionMap = {
    "Frontal": "FRONT",
    "Lateral": "SIDE",
    "Em Ângulo": "ANGLE",
  };

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

  Future<List<Ponto>> filterPontos(
    String? nameText,
    String? referenceText,
    String? addressText,
    String? typeText,
    String? orientationText,
    String? materialText,
    String? faceText,
  ) async {
    Map<String, String> queryParams = {};

    if (nameText != null && nameText.trim().isNotEmpty) {
      queryParams['filter[_name]'] = 'like';
      queryParams['filter[name]'] = nameText.trim();
    }
    if (referenceText != null && referenceText.trim().isNotEmpty) {
      queryParams['filter[_reference]'] = 'like';
      queryParams['filter[reference]'] = referenceText.trim();
    }
    if (addressText != null && addressText.trim().isNotEmpty) {
      queryParams['filter[_address]'] = 'like';
      queryParams['filter[address]'] = addressText.trim();
    }

    final kindValue = (typeText != null && typeText.isNotEmpty)
        ? (kindMap[typeText] ?? typeText)
        : null;
    if (kindValue != null && kindValue.isNotEmpty) {
      queryParams['filter[_kind]'] = 'like';
      queryParams['filter[kind]'] = kindValue;
    }

    final materialValue = (materialText != null && materialText.isNotEmpty)
        ? (materialMap[materialText] ?? materialText)
        : null;
    if (materialValue != null && materialValue.isNotEmpty) {
      queryParams['filter[_material]'] = 'like';
      queryParams['filter[material]'] = materialValue;
    }

    final orientationValue =
        (orientationText != null && orientationText.isNotEmpty)
        ? (orientationMap[orientationText] ?? orientationText)
        : null;
    if (orientationValue != null && orientationValue.isNotEmpty) {
      queryParams['filter[_orientation]'] = 'like';
      queryParams['filter[orientation]'] = orientationValue;
    }

    final faceValue = (faceText != null && faceText.isNotEmpty)
        ? (facePositionMap[faceText] ?? faceText)
        : null;
    if (faceValue != null && faceValue.isNotEmpty) {
      queryParams['filter[_facePosition]'] = 'like';
      queryParams['filter[facePosition]'] = faceValue;
    }

    final uri = Uri.https(
      'sinestro.mediamesh.com.br',
      '/api/pops',
      queryParams,
    );

    final response = await http.get(
      uri,
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

  @override
  void initState() {
    super.initState();
    pontos = fetchPontos();
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
                    children: [TextSpan(text: "Filtrar Pontos")],
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
                  controller: nameController,
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
                child: TextFormField(
                  controller: referenceController,
                  decoration: const InputDecoration(
                    labelText: "Referência",
                    border: OutlineInputBorder(),
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
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Endereço",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Posição ao fluxo",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: ['Frontal', 'Lateral', 'Em Ângulo']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedFacePosition = val),

                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Material",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: ['Estático', 'Digital', 'Vinil']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedMaterial = val),

                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Tipo",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: ['Outdoor', 'Indoor', 'Elevador']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedType = val),

                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Orientação",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: ['Vertical', 'Horizontal', 'Neutra']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedOrientation = val),

                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
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
                    onPressed: () async {
                      try {
                        pontos = filterPontos(
                          nameController.text,
                          referenceController.text,
                          addressController.text,
                          selectedType,
                          selectedOrientation,
                          selectedMaterial,
                          selectedFacePosition,
                        );

                        Navigator.of(drawerContext).pop();
                        setState(() {
                          selectedType = null;
                          selectedMaterial = null;
                          selectedOrientation = null;
                          selectedFacePosition = null;
                          nameController.clear();
                          referenceController.clear();
                          addressController.clear();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(
                          drawerContext,
                        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                      }
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
        title: const Text(
          "Pontos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),

        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt_sharp),
            color: Colors.white,
            iconSize: 32,
            onPressed: () async {
              final pontoCriado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewPops()),
              );

              if (pontoCriado != null) {
                setState(() {
                  pontos = fetchPontos();
                });
              }
            },
          ),

          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
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
            return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final ponto = lista[index];
                return Card(
                  child: Slidable(
                    key: ValueKey(ponto.id),
                    endActionPane: ActionPane(
                      extentRatio: 0.70,

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
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListPop(ponto: ponto),
                              ),
                            );
                          },
                          backgroundColor: Colors.deepPurple,
                          icon: Icons.remove_red_eye,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      iconColor: Colors.red.shade300,
                      title: Text(ponto.name),
                      subtitle: Text(ponto.reference),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
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
