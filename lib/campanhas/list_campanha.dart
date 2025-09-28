import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'campanha.dart';

class ListCampanha extends StatelessWidget {
  final Campanha campanha;

  const ListCampanha({super.key, required this.campanha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(campanha.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Nome"),
              subtitle: Text(campanha.name),
            ),
            ListTile(
              title: const Text("PI"),
              subtitle: Text(campanha.pi),
            ),
            ListTile(
              title: const Text("Status"),
              subtitle: Text(campanha.status),
            ),

            ListTile(title: const Text("Nome Anunciante"), 
            subtitle: Text(campanha.campanhaContratante.name)
            ),
            ListTile(title: const Text("CNPJ Anunciante"), 
            subtitle: Text(campanha.campanhaContratante.taxId)
            ),
            ListTile(
              title: const Text("Data de Início"),
              subtitle: Text(campanha.startDate.toString()),
            ),
            ListTile(
              title: const Text("Data de Fim"),
              subtitle: Text(campanha.endDate.toString()),
            ),
            ListTile(
              title: const Text("Endereço"),
              subtitle: Text(campanha.address),
            ),

            ListTile(
              title: const Text("Região"),
              subtitle: Text(campanha.region),
            ),

            ListTile(
              title: const Text("Produto"),
              subtitle: Text(campanha.product),
            ),
            ListTile(
              title: const Text("Formato"),
              subtitle: Text(campanha.format),
            ),

            // adiciona outros campos do Ponto que quiser
          ],
        ),
      ),
    );
  }
}
