import 'package:flutter/material.dart';
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
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'pontos/list_pop.dart';
// import 'home/home.dart';

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
      body: const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
