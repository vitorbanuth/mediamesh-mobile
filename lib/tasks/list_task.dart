import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'task_model.dart';

class ListTask extends StatelessWidget {
  final Task task;

  const ListTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Descrição"),
              subtitle: Text(task.description),
            ),
            ListTile(
              title: const Text("Data de inicio"),
              subtitle: Text(task.startDate),
            ),
            ListTile(
              title: const Text("Data de fim"),
              subtitle: Text(task.endDate),
            ),

            ListTile(title: const Text("Status"), subtitle: Text(task.status)),
            ListTile(
              title: const Text("Encarregado"),
              subtitle: Text(task.assignee),
            ),

            // adiciona outros campos do Ponto que quiser
          ],
        ),
      ),
    );
  }
}
