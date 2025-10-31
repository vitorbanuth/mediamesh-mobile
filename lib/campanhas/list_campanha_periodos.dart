import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'campanha.dart';

class CampanhaPeriodos extends StatefulWidget {
  final String cmpgnName;
  final String cmpgnUnique;
  final CampanhaPonto pop;

  const CampanhaPeriodos({
    super.key,
    required this.pop,
    required this.cmpgnName,
    required this.cmpgnUnique,
  });

  @override
  State<CampanhaPeriodos> createState() => _CampanhaPeriodosState();
}

class _CampanhaPeriodosState extends State<CampanhaPeriodos> {
  late List<Periods> periods;

  @override
  void initState() {
    super.initState();
    periods = widget.pop.periods;
  }

  Future<Uint8List> fetchImageBytes(
    String url,
    Map<String, String> headers,
  ) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Erro ${response.statusCode}');
    }
  }

  final Map<bool, String> isBonusMap = {true: "Sim", false: "Não"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pop.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add_location_alt_sharp),
        //     color: Colors.white,
        //     iconSize: 32,
        //     onPressed: () async {
        //       final pontoCriado = await Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => NewPops()),
        //       );
        //       if (pontoCriado != null) {
        //         setState(() {
        //           lista.add(pontoCriado);
        //         });
        //       }
        //     },
        //   ),
        // ],
      ),

      body: ListView.builder(
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final periodo = periods[index];
          return Card(
            child: Slidable(
              key: ValueKey(periodo.unique),
              endActionPane: ActionPane(
                extentRatio: 0.9,
                motion: const DrawerMotion(),
                children: [
                  CustomSlidableAction(
                    onPressed: (context) async {
                      final url =
                          'https://sinestro.mediamesh.com.br/storage/campaigns/${widget.cmpgnUnique}/arts/${periodo.hash}-th';
                      final headers = {
                        'Cookie':
                            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
                      };

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Prévia da arte')),
                            body: Center(
                              child: FutureBuilder<Uint8List>(
                                future: fetchImageBytes(url, headers),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      'Erro ao carregar imagem',
                                    );
                                  } else {
                                    return InteractiveViewer(
                                      child: Image.memory(snapshot.data!),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  CustomSlidableAction(
                    onPressed: (context) async {
                      // TODO LOAD CHECKING
                    },
                    backgroundColor: Colors.lightGreen.shade400,
                    child: const Icon(
                      Icons.check_box_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                iconColor: Colors.yellow.shade700,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${periodo.startDate} ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("até "),
                        Text(
                          "${periodo.endDate} ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Inserções / dia: "),
                        Text(
                          "${periodo.insertsDay}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Bonificado: "),
                        Text(
                          "${isBonusMap[periodo.isBonus]}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Inserções no período: "),
                        Text(
                          "${periodo.insertsPeriod}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Total de dias: "),
                        Text(
                          "${periodo.totalDays}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Ocupação slot/dia: "),
                        Text(
                          "${periodo.occupationDay}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                // subtitle: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text("${periodo.startDate} até ${periodo.endDate}"),
                //     const SizedBox(height: 16),
                //     Text("Inserções / dia: ${periodo.insertsDay}"),
                //     const SizedBox(height: 16),
                //     Text("Bonificado: ${periodo.isBonus}"),
                //     const SizedBox(height: 16),
                //     Text("Inserções no período: ${periodo.insertsPeriod}"),
                //     const SizedBox(height: 16),
                //     Text("Total de dias: ${periodo.totalDays}"),
                //     const SizedBox(height: 16),
                //     Text("Ocupação slot/dia: ${periodo.occupationDay}"),
                //   ],
                // ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
