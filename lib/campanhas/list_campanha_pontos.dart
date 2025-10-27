
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'campanha.dart';

class CampanhaPontos extends StatefulWidget {

  final Campanha cmpgn;

  const CampanhaPontos({super.key, required this.cmpgn});


  @override
  State<CampanhaPontos> createState() => _CampanhaPontosState();
}

class _CampanhaPontosState extends State<CampanhaPontos> {

  late List<CampanhaPonto> pops;

  @override
  void initState() {
    super.initState();
    pops = widget.cmpgn.campanhaPonto;
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Pontos",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue[900],
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.add_location_alt_sharp),
      //     color: Colors.white,
      //     iconSize: 32,
      //     onPressed: () async {
      //       final pontoCriado = await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => NewPops()),
      //       );
      //       if (pontoCriado != null) {
      //         setState(() {
      //           lista.add(pontoCriado);
      //         });
      //       }
      //     },
      //   ),
      // ],
    ),

    body: ListView.builder(
      itemCount: pops.length,
      itemBuilder: (context, index) {
        final ponto = pops[index];
        return Card(
          child: Slidable(
            key: ValueKey(ponto.id),
            endActionPane: ActionPane(
              extentRatio: 0.70,
              motion: const DrawerMotion(),
              children: [
                // Exemplo de ação futura (editar, excluir etc.)
                // SlidableAction(
                //   onPressed: (context) async {
                //     final pontoAtualizado = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => EditPops(ponto: ponto),
                //       ),
                //     );
                //     if (pontoAtualizado == true) {
                //       setState(() {
                //         // atualiza lista
                //       });
                //     }
                //   },
                //   backgroundColor: Colors.blue,
                //   icon: Icons.edit,
                // ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              iconColor: Colors.red.shade300,
              title: Text(ponto.name),
              subtitle: Text(ponto.reference),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        );
      },
    ),
  );
}

}
