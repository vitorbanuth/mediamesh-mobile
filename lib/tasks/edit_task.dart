import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_model.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final Task task;

  const EditTask({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TextEditingController uniqueController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? selectedStatus;
  final dateFormat = DateFormat('dd/MM/yyyy');

  final Map<String, String> statusMap = {
    "Nova": "NEW",
    "Em Progresso": "INPROGRESS",
    "Finalizada": "DONE",
  };

  final _formKey = GlobalKey<FormState>();

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "";
    try {
      final parsedDate = DateTime.parse(rawDate); // converte a string ISO
      return "${parsedDate.day.toString().padLeft(2, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.year}";
    } catch (e) {
      return rawDate;
    }
  }

  Future<void> updateTask({
    required String unique,
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String assignee,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://sinestro.mediamesh.com.br/api/tasks/${widget.task.unique}',
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
      body: jsonEncode({
        "unique": widget.task.unique,
        "title": titleController.text,
        "description": descriptionController.text,
        "status": statusMap[selectedStatus],
        "startDate": selectedStartDate?.toIso8601String(),
        "endDate": selectedEndDate?.toIso8601String(),
        "assignee": assigneeController.text,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tarefa atualizada com sucesso!")));
      Navigator.pop(context, result);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao editar Tarefa: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
    assigneeController.text = widget.task.assignee;
    startDateController.text = widget.task.startDate;
    endDateController.text = widget.task.endDate;
    selectedStartDate = dateFormat.parse(widget.task.startDate);
    selectedEndDate = dateFormat.parse(widget.task.endDate);
  }

  @override
  void dispose() {
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
        title: const Text("Editar Tarefa"),
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
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Atualize a Descrição"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Data de início",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  startDateController.text = formatDate(pickedDate.toString());

                  selectedStartDate = pickedDate;
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

                  endDateController.text = formatDate(pickedDate.toString());

                  selectedEndDate = pickedDate;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Status",
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
                      await updateTask(
                        unique: uniqueController.text,
                        title: titleController.text,
                        description: descriptionController.text,
                        startDate: startDateController.text,
                        endDate: endDateController.text,
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
                child: const Text("Salvar alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
