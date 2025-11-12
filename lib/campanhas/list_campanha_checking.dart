import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediamesh/campanhas/conta.dart';
import 'package:mediamesh/campanhas/list_book.dart';

class CampanhaChecking extends StatefulWidget {
  final String cmpgnUnq;

  const CampanhaChecking({super.key, required this.cmpgnUnq});

  @override
  State<CampanhaChecking> createState() => _CampanhaCheckingState();
}

class _CampanhaCheckingState extends State<CampanhaChecking> {
  late Future<List<Conta>> futureContas;
  String contaUnique = "";

  final Map<String, Future<Uint8List>> _imageCache = {};

  bool light0 = false;
  bool light1 = false;
  bool light2 = false;
  bool showButton = false;

  Future<List<Conta>> fetchConta() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/accounts'),
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
        return jsonList.map((json) => Conta.fromJson(json)).toList();
      }

      if (decoded is List) {
        return decoded.map((json) => Conta.fromJson(json)).toList();
      }

      throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao carregar contas [${response.statusCode}]: ${response.body}',
      );
    }
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

  Future<Uint8List> getImageForAccount(
    String url,
    Map<String, String> headers,
  ) {
    // se a conta já foi carregada antes, retorna o mesmo Future
    if (_imageCache.containsKey(url)) {
      return _imageCache[url]!;
    }

    // senão, faz o fetch e salva no cache
    final future = fetchImageBytes(url, headers);
    _imageCache[url] = future;
    return future;
  }

  Future<bool> generateChecking(String contaUnq) async {
    final response = await http.post(
      Uri.parse('https://books.mediamesh.com.br/api/books/generated'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
      body: jsonEncode({
        "account": {"unique": contaUnq},
        "art299": light0,
        "attachments": [],
        "bonusLetter": light1,
        "insertionsDoc": light2,
        "insertionsDocBlob": {},
        "insertionsDocHash": "",
        "unique": "${widget.cmpgnUnq}",
        "v2": false,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Checking gerado")));

      Navigator.pop(context, result);
      return true;
    } else {
      throw Exception("Erro ao gerar checking: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    futureContas = fetchConta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checking",
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 4),
                Icon(Icons.table_rows_rounded),
                const SizedBox(width: 4),
                Text(
                  "Opções",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Switch(
                  activeTrackColor: Colors.blue.shade900,
                  activeThumbColor: Colors.white,
                  value: light0,
                  onChanged: (value) {
                    setState(() {
                      light0 = value;
                    });
                  },
                ),
                const SizedBox(width: 4),
                Text("Adicionar carta Art. 299"),
              ],
            ),

            Row(
              children: [
                Switch(
                  activeTrackColor: Colors.blue.shade900,
                  activeThumbColor: Colors.white,
                  value: light1,
                  onChanged: (value) {
                    setState(() {
                      light1 = value;
                    });
                  },
                ),
                const SizedBox(width: 4),
                Text("Adicionar carta de bonificação"),
              ],
            ),

            Row(
              children: [
                Switch(
                  activeTrackColor: Colors.blue.shade900,
                  activeThumbColor: Colors.white,
                  value: light2,
                  onChanged: (value) {
                    setState(() {
                      light2 = value;
                    });
                  },
                ),
                const SizedBox(width: 4),
                Text("Adicionar relatório de inserções"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 4),
                Icon(Icons.business_center_sharp),
                const SizedBox(width: 4),
                Text(
                  "Selecione a conta",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Flexible(

            // child:
            FutureBuilder(
              future: futureContas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erro: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhuma conta cadastrada."));
                }

                final contas = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contas.length,
                  itemBuilder: (context, index) {
                    final conta = contas[index];
                    final accountUrl =
                        'https://sinestro.mediamesh.com.br/storage/accounts/${conta.unique}/logo/${conta.logo.hash}';

                    final headers = {
                      'Cookie':
                          'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
                    };
                    // Dentro do itemBuilder do ListView
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            showButton = !showButton;
                            contaUnique = conta.unique;
                          });
                        },
                        splashColor: Colors.blue.withOpacity(0.2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double
                              .infinity, // ocupa a largura disponível do ListView
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: showButton
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: showButton
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              FutureBuilder<Uint8List>(
                                future: getImageForAccount(accountUrl, headers),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      'Erro ao carregar imagem',
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                    // );
                                  }
                                },
                              ),
                              const SizedBox(width: 12),

                              Flexible(
                                // garante que o texto respeite a largura
                                child: Column(
                                  children: [
                                    Text(
                                      conta.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      conta.taxId,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
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
            // ),
            Center(
              child: Visibility(
                visible: showButton,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool flag = await generateChecking(contaUnique);

                      if (flag == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListBook(cmpgnUnq: widget.cmpgnUnq),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: const Text(
                      "Gerar checking",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
