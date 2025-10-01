import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewAgencia extends StatefulWidget {
  const NewAgencia({super.key});

  @override
  State<NewAgencia> createState() => _NewAgenciaState();
}

class _NewAgenciaState extends State<NewAgencia> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();

  Future<void> createAgencia() async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/agencies/new'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
      body: jsonEncode({
        "taxId": cnpjController.text,
        "name": nameController.text,
        "contact": {
          "name": contactNameController.text,
          "email": contactEmailController.text,
          "phone": contactPhoneController.text,
        },
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Agência criada: ${result['name']}")),
      );
      Navigator.pop(context, result);
    } else {
      throw Exception("Erro ao criar agência: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Agência")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cnpjController,
                decoration: const InputDecoration(labelText: "CNPJ"),
                validator: (v) => v!.isEmpty ? "Preencha o CNPJ" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome da Agência"),
                validator: (v) => v!.isEmpty ? "Preencha o nome" : null,
              ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 16),
              const Text("Contato", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: contactNameController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactEmailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactPhoneController,
                decoration: const InputDecoration(labelText: "Telefone"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await createAgencia();
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
