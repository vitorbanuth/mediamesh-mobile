import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'pop.dart';

class ListPop extends StatelessWidget {
  final Ponto ponto;

  const ListPop({super.key, required this.ponto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ponto.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(title: const Text("Nome"), subtitle: Text(ponto.name)),
            ListTile(
              title: const Text("Referência"),
              subtitle: Text(ponto.reference),
            ),
            ListTile(
              title: const Text("Endereço"),
              subtitle: Text(ponto.address),
            ),
            ListTile(
              title: const Text("Largura"),
              subtitle: Text(ponto.dimensions.width.toString() + "" + ponto.dimensions.unit),
            ),
            ListTile(
              title: const Text("Altura"),
              subtitle: Text(ponto.dimensions.height.toString()  + "" + ponto.dimensions.unit),
            ),
            ListTile(
              title: const Text("Tipo"),
              subtitle: Text(ponto.kind),
            ),
            ListTile(
              title: const Text("Material"),
              subtitle: Text(ponto.material),
            ),
            ListTile(
              title: const Text("Posição ao fluxo"),
              subtitle: Text(ponto.facePosition),
            ),

            ListTile(
              title: const Text("Orientação"),
              subtitle: Text(ponto.orientation),
            ),
            
            // adiciona outros campos do Ponto que quiser
          ],
        ),
      ),
    );
  }
}
