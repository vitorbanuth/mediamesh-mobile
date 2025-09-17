import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewContratante extends StatefulWidget {
  const NewContratante({Key? key}) : super(key: key);

  @override
  State<NewContratante> createState() => _NewContratanteState();
}

class _NewContratanteState extends State<NewContratante> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();

  String? selectedSector;

  final Map<String, String> sectorMap = {
    "Publico": "PUBLIC",
    "Privado": "PRIVATE",
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> createContratante({
    required String name,
    required String taxId,
    required String sector,
    required String address,
    required String cep,
    required String contactName,
    required String contactEmail,
    required String contactPhone,
  }) async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/advertisers/new'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%229E4DQBPR%22%2C%22apiVersion%22%3A%22993fda5c%22%2C%22account%22%3A%7B%22taxId%22%3A%2210276433000128%22%2C%22alias%22%3A%22devs%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22name%22%3A%22Ksmz%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%7D%7D.ovxaACdIZDF7tU3Z%2BgPfGTJXdKP6QWWieeyi%2FbD5nms',
      },
      body: jsonEncode({
        "taxId": taxId,
        "name": name,
        "sector": sectorMap[sector],
        "contact": {
          "name": contactName,
          "email": contactEmail,
          "phone": contactPhone,
        },
        "address": address,
        "cep": cep,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contratante criado: ${result['name']}")),
      );
      Navigator.pop(context, result);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao criar contratante: ${response.body}');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cnpjController.dispose();
    addressController.dispose();
    cepController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Contratante"),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cnpjController,
                decoration: const InputDecoration(
                  labelText: "CNPJ",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Preencha o CNPJ" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nome da Empresa",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Preencha o nome" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Setor",
                  border: OutlineInputBorder(),
                ),
                items: ["Publico", "Privado"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedSector = val),
                validator: (val) => val == null ? "Escolha um setor" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o endereço"
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: cepController,
                decoration: const InputDecoration(
                  labelText: "CEP",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Preencha o CEP" : null,
              ),
              const SizedBox(height: 16),

              const Divider(),
              const Text(
                "Informações de Contato",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: contactNameController,
                decoration: const InputDecoration(
                  labelText: "Nome do Contato",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o nome do contato"
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: contactEmailController,
                decoration: const InputDecoration(
                  labelText: "Email do Contato",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o email do contato"
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: contactPhoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone do Contato",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o telefone do contato"
                    : null,
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await createContratante(
                        name: nameController.text,
                        taxId: cnpjController.text,
                        sector: selectedSector!,
                        address: addressController.text,
                        cep: cepController.text,
                        contactName: contactNameController.text,
                        contactEmail: contactEmailController.text,
                        contactPhone: contactPhoneController.text,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                    }
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
