import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contratante_model.dart';

class EditContratantes extends StatefulWidget {
  final Contratante contratante;

  const EditContratantes({Key? key, required this.contratante}) : super(key: key);

  @override
  State<EditContratantes> createState() => _EditContratantesState();
}

class _EditContratantesState extends State<EditContratantes> {
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

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contratante.name;
    cnpjController.text = widget.contratante.taxId;
    addressController.text = widget.contratante.address;
    cepController.text = widget.contratante.cep;
    contactNameController.text = widget.contratante.contact.name;
    contactEmailController.text = widget.contratante.contact.email;
    contactPhoneController.text = widget.contratante.contact.phone;
    selectedSector = sectorMap.entries
        .firstWhere(
          (e) => e.value == widget.contratante.sector,
          orElse: () => MapEntry("Publico", "PUBLIC"),
        )
        .key;
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

  Future<void> updateContratante({
    required String taxId,
    required String name,
    required String sector,
    required String address,
    required String cep,
    required String contactName,
    required String contactEmail,
    required String contactPhone,
  }) async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/advertisers/$taxId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
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
        SnackBar(content: Text("Contratante atualizado: ${result['name']}")),
      );
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao atualizar contratante: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Contratante"),
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
                value: selectedSector,
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
                      await updateContratante(
                        taxId: cnpjController.text,
                        name: nameController.text,
                        sector: selectedSector!,
                        address: addressController.text,
                        cep: cepController.text,
                        contactName: contactNameController.text,
                        contactEmail: contactEmailController.text,
                        contactPhone: contactPhoneController.text,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Contratante atualizado com sucesso!")),
                      );
                      Navigator.pop(context, true);
                    } catch (e) {
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