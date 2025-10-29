import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:mediamesh/agencias/agencia_model.dart';
import 'package:mediamesh/campanhas/list_campanha.dart';
import 'package:mediamesh/contratantes/contratante_model.dart';
import 'campanha.dart';
import 'list_campanha_pontos.dart';

class Campanhas extends StatefulWidget {
  const Campanhas({super.key});

  @override
  State<Campanhas> createState() => _CampanhasState();
}

class _CampanhasState extends State<Campanhas> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  String? selectedAdvertiser;
  String? selectedAgency;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? selectedStatus;
  List<String> advertiserNameArr = [];
  List<String> agencyNameArr = [];

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "";
    try {
      final parsedDate = DateTime.parse(rawDate);
      return "${parsedDate.day.toString().padLeft(2, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.year}";
    } catch (e) {
      return rawDate;
    }
  }

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
        'Erro ao carregar campanhas [${response.statusCode}]: ${response.body}',
      );
    }
  }

  late Future<List<Contratante>> futureContratantes;

  Future<List<Contratante>> fetchContratantes() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/advertisers'),
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

  late Future<List<Agencia>> futureAgencias;

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
        final List<dynamic> jsonList = decoded["data"];
        return jsonList.map((json) => Agencia.fromJson(json)).toList();
      }

      if (decoded is List) {
        return decoded.map((json) => Agencia.fromJson(json)).toList();
      }

      throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao carregar contratantes [${response.statusCode}]: ${response.body}',
      );
    }
  }

  final Map<String, String> kindMap = {
    "Outdoor": "OUTDOOR",
    "Indoor": "INDOOR",
    "Elevador": "ELEVATOR",
  };

  Future<List<Campanha>> filterCampanhas(
    String? nameText,
    String? addressText,
    String? advertiserTaxIdText,
    String? agencyTaxIdText,
    DateTime? startDateText,
    DateTime? endDateText,
    String? statusText,
  ) async {
    Map<String, String> queryParams = {};

    if (nameText != null && nameText.trim().isNotEmpty) {
      queryParams['filter[_name]'] = 'like';
      queryParams['filter[name]'] = nameText.trim();
    }

    if (addressText != null && addressText.trim().isNotEmpty) {
      queryParams['filter[_address]'] = 'like';
      queryParams['filter[address]'] = addressText.trim();
    }

    if (advertiserTaxIdText != null && advertiserTaxIdText.trim().isNotEmpty) {
      queryParams['filter[advertiser][taxId]'] = advertiserTaxIdText.trim();
    }

    if (agencyTaxIdText != null && agencyTaxIdText.trim().isNotEmpty) {
      queryParams['filter[agency][taxId]'] = agencyTaxIdText.trim();
    }

    if (startDateText != null) {
      queryParams['filter[_startDate]'] = 'gte';
      queryParams['filter[startDate]'] = startDateText.toIso8601String();
    }

    if (endDateText != null) {
      queryParams['filter[_endDate]'] = 'lte';
      queryParams['filter[endDate]'] = endDateText.toIso8601String();
    }

    final statusValue = (statusText != null && statusText.isNotEmpty)
        ? (kindMap[statusText] ?? statusText)
        : null;
    if (statusValue != null && statusValue.isNotEmpty) {
      // queryParams['filter[_kind]'] = 'like';
      queryParams['filter[status]'] = statusValue;
    }

    final uri = Uri.https(
      'sinestro.mediamesh.com.br',
      '/api/campaigns',
      queryParams,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse["data"] ?? [];
      return data.map((json) => Campanha.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao carregar campanhas: ${response.statusCode}");
    }
  }

  final colorMap = {
    "Novo": Colors.blue.shade700,
    "Publicada": Colors.green.shade400,
    "Finalizada": Colors.grey.shade900,
    "Faturada": Colors.amber.shade700,
  };

  @override
  void initState() {
    super.initState();
    futureCampanhas = fetchCampanhas();
    futureContratantes = fetchContratantes();
    futureAgencias = fetchAgencias();

    futureContratantes
        .then((contratantes) {
          setState(() {
            advertiserNameArr = contratantes.map((c) => c.name).toList();
          });
        })
        .catchError((error) {
          print("Erro ao buscar contratantes: $error");
        });

    futureAgencias
        .then((agencias) {
          setState(() {
            agencyNameArr = agencias.map((c) => c.name).toList();
          });
        })
        .catchError((error) {
          print("Erro ao buscar contratantes: $error");
        });
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
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Anunciante",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: advertiserNameArr
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedAdvertiser = val),

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
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Agência",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: agencyNameArr
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedAgency = val),
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
                child: TextFormField(
                  controller: startDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Data de início",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    startDateController.text = formatDate(
                      pickedDate.toString(),
                    );

                    selectedStartDate = pickedDate;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  controller: endDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Data de Fim",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    endDateController.text = formatDate(pickedDate.toString());

                    selectedEndDate = pickedDate;
                  },
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
                    labelText: "Status",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: ['Nova', 'Publicada', 'Finalizada', 'Faturada']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedStatus = val),

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
                        futureCampanhas = filterCampanhas(
                          nameController.text,
                          addressController.text,
                          startDateController.text,
                          endDateController.text,
                          selectedStartDate,
                          selectedEndDate,
                          selectedStatus,
                        );

                        Navigator.of(drawerContext).pop();
                        setState(() {
                          selectedStatus = null;
                          selectedStartDate = null;
                          selectedEndDate = null;
                          nameController.clear();
                          addressController.clear();
                          startDateController.clear();
                          endDateController.clear();
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
            return const Center(child: Text("Nenhuma campanha cadastrada."));
          }

          final campanhas = snapshot.data!;
          return ListView.builder(
            itemCount: campanhas.length,
            itemBuilder: (context, index) {
              final c = campanhas[index];
              return Card(
                color: colorMap[c.status],
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
                        backgroundColor: Colors.pink.shade600,
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
                    iconColor: Colors.white,
                    leading: Icon(Icons.campaign),
                    title: Text(
                      c.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          "Status: ${c.status} ",
                          style: TextStyle(color: Colors.white), // cor do texto
                        ),
                        const SizedBox(height: 16),
                        // espaçamento opcional
                        Text(
                          "${c.startDate} até ${c.endDate}",
                          style: TextStyle(color: Colors.white), // cor do texto
                        ),
                      ],
                    ),
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

// • ${c.startDate} • ${c.endDate}
