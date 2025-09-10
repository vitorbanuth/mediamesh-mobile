import 'package:flutter/material.dart';
import 'pontos/pops.dart';
import 'contratantes/contratantes.dart';
import 'agencias/agencias.dart';
import 'arquivos/arquivos.dart';
import 'campanhas/campanhas.dart';
import 'configuracoes/configuracoes.dart';
import 'home/home.dart';

// import 'assets/';
void main() {
  runApp(const MyApp());
}

const drawerRoutes = {
  1: '/pontos',
  2: '/contratantes',
  3: '/agencias',
  4: '/arquivos',
  5: '/campanhas',
  6: '/configuracoes',
  7: '/home',
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediamesh',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.blue.shade900,
          onPrimary: Colors.white,
          secondary: Colors.blue.shade700,
          onSecondary: Colors.white,
          error: Colors.red.shade700,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
      ),
      home: const MyHomePage(title: 'Mediamesh'),
      routes: {
        '/pontos': (context) => const Pontos(),
        '/contratantes': (context) => const Contratantes(),
        '/agencias': (context) => const Agencias(),
        '/arquivos': (context) => const Arquivos(),
        '/campanhas': (context) => const Campanhas(),
        '/configuracoes': (context) => const Configuracoes(),
        '/home': (context) => const Home(),
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
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
