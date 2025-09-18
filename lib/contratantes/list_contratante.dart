import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'contratante_model.dart';

class ListContratante extends StatelessWidget {
  final Contratante contratante;

  const ListContratante({super.key, required this.contratante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contratante.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text("CNPJ"),
              subtitle: Text(contratante.taxId),
            ),
            ListTile(
              title: const Text("Endereço"),
              subtitle: Text(contratante.address),
            ),

            ListTile(title: const Text("CEP"), subtitle: Text(contratante.cep)),
            ListTile(
              title: const Text("Setor"),
              subtitle: Text(contratante.sector),
            ),
            ListTile(
              title: const Text("Nome de contato principal"),
              subtitle: Text(contratante.contact.name),
            ),
            ListTile(
              title: const Text("E-mail"),
              subtitle: Text(contratante.contact.email),
            ),

            ListTile(
              title: const Text("Telefone"),
              subtitle: Text(contratante.contact.phone),
            ),

            // adiciona outros campos do Ponto que quiser
          ],
        ),
      ),
    );
  }
}
