import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewTask extends StatefulWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? selectedStatus;

  final Map<String, String> statusMap = {
    "Nova": "NEW",
    "Em Progresso": "INPROGRESS",
    "Finalizada": "DONE",
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> createTask({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String assignee,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/tasks/new'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "status": statusMap[status],
        "startDate": selectedStartDate?.toIso8601String(),
        "endDate": selectedEndDate?.toIso8601String(),
        "assignee": assignee,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tarefa criada com sucesso!")),
      );
      Navigator.pop(context, result);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao criar Tarefa: ${response.body}');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    assigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Tarefa"),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o Título"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha a Descrição"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Data de Início",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    // locale: const Locale("pt", "BR"),
                  );

                  if (pickedDate != null) {
                    selectedStartDate = pickedDate;

                    // Mostra no campo no formato brasileiro
                    startDateController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Data de Fim",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    selectedEndDate = pickedDate;

                    // Mostra no campo no formato brasileiro
                    endDateController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Setor",
                  border: OutlineInputBorder(),
                ),
                items: ["Nova", "Em Progresso", "Finalizada"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStatus = val),
                validator: (val) => val == null ? "Escolha um Status" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: assigneeController,
                decoration: const InputDecoration(
                  labelText: "Encarregado",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o Encarregado"
                    : null,
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await createTask(
                        title: titleController.text,
                        description: descriptionController.text,
                        startDate: selectedStartDate!,
                        endDate: selectedEndDate!,
                        status: selectedStatus!,
                        assignee: assigneeController.text,
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
