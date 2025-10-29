import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'campanha.dart';

class ListCampanha extends StatelessWidget {
  final Campanha campanha;

  const ListCampanha({super.key, required this.campanha});

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
  Widget build(BuildContext context) {
    final inicio = formatDate(campanha.startDate);
    final fim = formatDate(campanha.endDate);
    final status = getStatus(campanha.status);

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
              subtitle: Text(
                status,
                style: TextStyle(
                  color: getStatusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              title: const Text("Nome Anunciante"),
              subtitle: Text(campanha.campanhaContratante.name),
            ),
            ListTile(
              title: const Text("CNPJ Anunciante"),
              subtitle: Text(campanha.campanhaContratante.taxId),
            ),
            ListTile(
              title: const Text("Data de Início"),
              subtitle: Text(inicio),
            ),
            ListTile(
              title: const Text("Data de Fim"),
              subtitle: Text(fim),
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
