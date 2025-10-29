import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agencia_model.dart';

class EditAgencia extends StatefulWidget {
  final Agencia agencia;

  const EditAgencia({Key? key, required this.agencia}) : super(key: key);

  @override
  State<EditAgencia> createState() => _EditAgenciaState();
}

class _EditAgenciaState extends State<EditAgencia> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cnpjController.text = widget.agencia.taxId;
    nameController.text = widget.agencia.name;
    contactNameController.text = widget.agencia.contact.name;
    contactEmailController.text = widget.agencia.contact.email;
    contactPhoneController.text = widget.agencia.contact.phone;

  }

    @override
  void dispose() {
    nameController.dispose();
    cnpjController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> updateAgencia({
    required String taxId,
    required String name,
    required String contactName,
    required String contactEmail,
    required String contactPhone,
  }) async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/agencies/$taxId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
      body: jsonEncode({
        "taxId": taxId,
        "name": name,
        "contact": {
          "name": contactName,
          "email": contactEmail,
          "phone": contactPhone,
        }
      }),
    );

    if(response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Agencia atualizada: ${result['name']}")),
      );
    }else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao atualizar agencia: ${response.body}');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Agência"),
      // backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cnpjController,
                decoration: const InputDecoration(labelText: "CNPJ", border: OutlineInputBorder(),),
                // validator: (v) => v!.isEmpty ? "Preencha o CNPJ" : null,
                validator: (value) =>
                    value == null || value.isEmpty ? "Preencha o CNPJ" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome da Agência", border: OutlineInputBorder(),),
                // validator: (v) => v!.isEmpty ? "Preencha o nome" : null,
                validator: (value) =>
                    value == null || value.isEmpty ? "Preencha o nome" : null,
              ),

              const SizedBox(height: 16),
              
              const SizedBox(height: 16),
              const Text("Contato", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: contactNameController,
                decoration: const InputDecoration(labelText: "Nome", border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o nome do contato"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactEmailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o email do contato"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactPhoneController,
                decoration: const InputDecoration(labelText: "Telefone", border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o telefone do contato"
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await updateAgencia(
                      taxId: cnpjController.text, 
                      name: nameController.text, 
                      contactName: contactNameController.text, 
                      contactEmail: contactEmailController.text, 
                      contactPhone: contactPhoneController.text
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Agência atualizada com sucesso!")),
                      );
                       Navigator.pop(context, true);

                    }catch(e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erro: $e")),
                      );
                    }
                    
                  }
                },
                child: const Text("Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
