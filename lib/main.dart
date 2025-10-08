import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediamesh/tasks/new_task.dart';
import 'pontos/pops.dart';
import 'contratantes/contratantes.dart';
import 'agencias/agencias.dart';
import 'arquivos/arquivos.dart';
import 'campanhas/campanhas.dart';
import 'configuracoes/configuracoes.dart';
import 'tasks/tasks.dart';
import 'contratantes/new_contratante.dart';
import 'agencias/new_agencia.dart';
import 'home.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'pontos/list_pop.dart';

// import 'assets/';
void main() {
  runApp(const MyApp());
}

const drawerRoutes = {
  0: '/home',
  1: '/pontos',
  2: '/tarefas',
  3: '/contratantes',
  4: '/agencias',
  5: '/campanhas',
  6: '/arquivos',
  7: '/configuracoes',
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediamesh',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.blue.shade700,
          onSecondary: Colors.white,
          error: Colors.red.shade700,
          onError: Colors.white,
          surface: Colors.grey.shade200,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'Mediamesh'),
      routes: {
        '/pontos': (context) => const Pontos(),
        '/contratantes': (context) => const Contratantes(),
        '/agencias': (context) => const Agencias(),
        '/tarefas': (context) => const Tasks(),
        '/arquivos': (context) => const Arquivos(),
        '/campanhas': (context) => const Campanhas(),
        '/configuracoes': (context) => const Configuracoes(),
        '/new_contratante': (context) => NewContratante(),
        '/new_agencia': (context) => NewAgencia(),
        '/new_task': (context) => NewTask(),
        // '/listagempontos': (context) => const ListPop()
        // '/home': (context) => const Home(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Home> fetchHome() async {
    final response = await http.get(
      Uri.parse('https://sinestro.mediamesh.com.br/api/home'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Home.fromJson(jsonResponse);
    } else {
      throw Exception('Erro ao carregar dados');
    }
  }

  late Future<Home> homeInfos;

  @override
  void initState() {
    super.initState();
    homeInfos = fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset('assets/image.png', height: 40),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: (index) {
          final route = drawerRoutes[index];
          if (route != null) {
            Navigator.pushNamed(context, route);
          }
        },
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "OOH"),
                  TextSpan(
                    text: "360",
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
          ),

          NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text("Home"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.place_outlined),
            selectedIcon: Icon(Icons.place),
            label: Text("Pontos"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: Text("Tarefas"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.business_center_outlined),
            selectedIcon: Icon(Icons.business_center),
            label: Text("Contratantes"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.apartment_outlined),
            selectedIcon: Icon(Icons.apartment),
            label: Text("Agências"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: Text("Campanhas"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: Text("Arquivos"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text("Configurações"),
          ),
        ],
      ),

      body: FutureBuilder<Home>(
        future: homeInfos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            print(snapshot.data);
            final home = snapshot.data!;
            return Column(
              children: [

                SizedBox(height: 15),

                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Visão Geral",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),

                
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      // O conteúdo
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),

                          Row(
                            children: [
                              Icon(Icons.add_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Novas Campanhas: ${home.campaignStatus.newStatus.toString()}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      // O conteúdo
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),

                          Row(
                            children: [
                              Icon(Icons.upload, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Campanhas Publicadas: ${home.campaignStatus.published.toString()}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      // O conteúdo
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),

                          Row(
                            children: [
                              Icon(Icons.check_box_outlined, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Campanhas Finalizadas: ${home.campaignStatus.done.toString()}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      // O conteúdo
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),

                          Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Campanhas Faturadas: ${home.campaignStatus.invoiced.toString()}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                
              ],
            );
          } else {
            return const Center(child: Text("Nenhum dado encontrado"));
          }
        }, // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
