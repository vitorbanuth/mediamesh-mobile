import 'package:flutter/material.dart';
import 'agencia_model.dart';

class ListAgencia extends StatelessWidget {
  final Agencia agencia;

  const ListAgencia({super.key, required this.agencia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(agencia.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(title: const Text("CNPJ"), subtitle: Text(agencia.taxId)),
            ListTile(title: const Text("Endereço"), subtitle: Text(agencia.address)),
            ListTile(title: const Text("CEP"), subtitle: Text(agencia.cep)),
            ListTile(title: const Text("Setor"), subtitle: Text(agencia.sector)),
            ListTile(title: const Text("Contato"), subtitle: Text(agencia.contact.name)),
            ListTile(title: const Text("Email"), subtitle: Text(agencia.contact.email)),
            ListTile(title: const Text("Telefone"), subtitle: Text(agencia.contact.phone)),
          ],
        ),
      ),
    );
  }
}
