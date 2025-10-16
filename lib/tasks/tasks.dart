import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mediamesh/tasks/edit_task.dart';
import 'package:mediamesh/tasks/list_task.dart';

import 'task_model.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = fetchTasks();
  }

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        final List<dynamic> jsonList = decoded["data"];
        return jsonList.map((json) => Task.fromJson(json)).toList();
      }

      if (decoded is List) {
        return decoded.map((json) => Task.fromJson(json)).toList();
      }

      throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao carregar tarefas [${response.statusCode}]: ${response.body}',
      );
    }
  }

  Future<void> deleteTask(String uniqueId) async {
    final response = await http.delete(
      Uri.parse('https://sinestro.mediamesh.com.br/api/tasks/$uniqueId'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      // final decoded = jsonDecode(response.body);

      // if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
      //   final List<dynamic> jsonList = decoded["data"];
      //   return jsonList.map((json) => Task.fromJson(json)).toList();
      // }

      // if (decoded is List) {
      //   return decoded.map((json) => Task.fromJson(json)).toList();
      // }

      // throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao deletar tarefa [${response.statusCode}]: ${response.body}',
      );
    }
  }

  final TextEditingController descriptionController = TextEditingController();

  String? selectedStatus;

  final Map<String, String> statusMap = {
    "Nova": "NEW",
    "Em Progresso": "INPROGRESS",
    "Finalizada": "DONE",
  };

  Future<List<Task>> filterTasks(String? statusText) async {
    Map<String, String> queryParams = {};

    final statusValue = (statusText != null && statusText.isNotEmpty)
        ? (statusMap[statusText] ?? statusText)
        : null;
    if (statusValue != null && statusValue.isNotEmpty) {
      queryParams['filter[_status]'] = 'like';
      queryParams['filter[status]'] = statusValue;
    }

    final uri = Uri.https(
      'sinestro.mediamesh.com.br',
      '/api/tasks',
      queryParams,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        final List<dynamic> jsonList = decoded["data"];
        return jsonList.map((json) => Task.fromJson(json)).toList();
      }

      if (decoded is List) {
        return decoded.map((json) => Task.fromJson(json)).toList();
      }

      throw Exception("Formato inesperado do JSON: $decoded");
    } else {
      throw Exception(
        'Erro ao carregar contratantes [${response.statusCode}]: ${response.body}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade200,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [TextSpan(text: "Filtrar Tarefas")],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                    iconColor: Colors.blueAccent,
                  ),
                  items: ['Nova', 'Em Progresso', 'Finalizada']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedStatus = val),

                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: Builder(
                  builder: (drawerContext) => ElevatedButton(
                    onPressed: () async {
                      try {
                        futureTasks = filterTasks(selectedStatus);

                        Navigator.of(drawerContext).pop();
                        setState(() {
                          selectedStatus = null;
                          descriptionController.clear();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(
                          drawerContext,
                        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Pesquisar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/new_task").then(
                (_) => setState(() {
                  futureTasks = fetchTasks();
                }),
              );
            },
            icon: Icon(Icons.assignment_add),
          ),

          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_alt_outlined, size: 28),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma tarefa cadastrada."));
          }

          final tarefas = snapshot.data!;
          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final t = tarefas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Slidable(
                  key: ValueKey(t.unique),
                  endActionPane: ActionPane(
                    extentRatio: 0.70,

                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTask(task: t),
                            ),
                          );

                          setState(() {
                            futureTasks = fetchTasks();
                          });
                        },
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListTask(task: t),
                            ),
                          );
                        },
                        backgroundColor: Colors.deepPurple,
                        icon: Icons.remove_red_eye,
                      ),

                      SlidableAction(
                        onPressed: (context) async {
                          await deleteTask(t.unique);
                          setState(() {
                            futureTasks = fetchTasks();
                          });
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    iconColor: Colors.blue.shade900,
                    leading: Icon(Icons.business_center),
                    title: Text(t.title),
                    subtitle: Text("${t.status} • Termina: ${t.endDate}"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
