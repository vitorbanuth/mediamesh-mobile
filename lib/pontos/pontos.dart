import 'package:flutter/material.dart';

class Pontos extends StatelessWidget {
  const Pontos({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pontos")),
      body: const Center(
        child: Text(
          "Tela de pontos!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
