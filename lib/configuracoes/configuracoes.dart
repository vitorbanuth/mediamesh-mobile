import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math; 


class StorageUsage {
  final int artsTotal;
  final int artsUsage;
  final int snapsTotal;
  final int snapsUsage;
  final int docsTotal;
  final int docsUsage;

  StorageUsage({
    required this.artsTotal,
    required this.artsUsage,
    required this.snapsTotal,
    required this.snapsUsage,
    required this.docsTotal,
    required this.docsUsage,
  });

   
  factory StorageUsage.fromJson(Map<String, dynamic> json) {
    return StorageUsage(
      artsTotal: json['artsTotal'] ?? 0,
      artsUsage: json['artsUsage'] ?? 0,
      snapsTotal: json['snapsTotal'] ?? 0,
      snapsUsage: json['snapsUsage'] ?? 0,
      docsTotal: json['docsTotal'] ?? 0,
      docsUsage: json['docsUsage'] ?? 0,
    );
  }

   
  int get totalUsage => artsUsage + snapsUsage + docsUsage;
}

Future<StorageUsage> fetchStorageUsage() async {

  const String apiCookie =
      'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE';

  final response = await http.get(
    Uri.parse('https://sinestro.mediamesh.com.br/api/home'),
    headers: {
      'Content-Type': 'application/json',
      'Cookie': apiCookie,
    },
  )
 
  .timeout(const Duration(seconds: 10));

  if (response.statusCode == 200) {
 
    final jsonBody = jsonDecode(response.body);
    final storageData = jsonBody['storageUsageTotal'];
    if (storageData != null) {
      return StorageUsage.fromJson(storageData);
    } else {
      throw Exception('Não foi possível encontrar "storageUsageTotal" na resposta');
    }
  } else {
    throw Exception('Falha ao carregar dados da API (Status Code: ${response.statusCode})');
  }
}


class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  late Future<StorageUsage> _futureStorageUsage;

  final double _totalStorageGB = 25;
  late final double _totalStorageBytes = _totalStorageGB * 1024 * 1024 * 1024;

  final Color _artsColor = const Color(0xFF2E6BFF); 
  final Color _snapsColor = const Color(0xFF7B2EFF);  
  final Color _docsColor = const Color(0xFF1ED760);  

  @override
  void initState() {
    super.initState();
    _futureStorageUsage = fetchStorageUsage();
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        elevation: 0,
      ),
      body: FutureBuilder<StorageUsage>(
        future: _futureStorageUsage,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar: ${snapshot.error}",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.hasData) {
            final storage = snapshot.data!;
            final double usedPercent = storage.totalUsage / _totalStorageBytes;
            final String usedMB = _formatBytes(storage.totalUsage);
            final String availableGB = _formatBytes((_totalStorageBytes - storage.totalUsage).toInt());

            return _buildStorageDetails(context, storage, usedPercent, usedMB, availableGB);
          }


          return Center(child: Text("Nenhum dado", style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)));
        },
      ),
    );
  }


  Widget _buildStorageDetails(BuildContext context, StorageUsage storage, double usedPercent, String usedMB, String availableGB) {
    final ThemeData theme = Theme.of(context);
    final Color barBackgroundColor = theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!;
    final Color textSecondaryColor = theme.textTheme.bodySmall?.color ?? Colors.grey[600]!;

    final double artsPercent = (storage.totalUsage > 0) ? storage.artsUsage / storage.totalUsage : 0;
    final double snapsPercent = (storage.totalUsage > 0) ? storage.snapsUsage / storage.totalUsage : 0;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Armazenamento", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text("Plano Starter (25 GB)", style: TextStyle(color: _artsColor, fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: usedPercent,
            minHeight: 12,
            backgroundColor: barBackgroundColor,
            color: _docsColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Utilizado: $usedMB de $_totalStorageGB GB | ${(usedPercent * 100).toStringAsFixed(1)}%",

          style: theme.textTheme.bodyMedium?.copyWith(color: textSecondaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Disponível: $availableGB",

          style: theme.textTheme.bodyMedium?.copyWith(color: textSecondaryColor),
        ),
        
        const SizedBox(height: 32),

        Text("Categorias", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                flex: (artsPercent * 100).toInt(),
                child: Container(height: 10, color: _artsColor),
              ),
              Expanded(
                flex: (snapsPercent * 100).toInt(),
                child: Container(height: 10, color: _snapsColor),
              ),

              Expanded(
                flex: (100 - (artsPercent * 100).toInt() - (snapsPercent * 100).toInt()).clamp(1, 100),
                child: Container(height: 10, color: _docsColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCategoryItem(
          context: context,
          color: _artsColor,
          title: "Peças",
          usage: storage.artsUsage,
          totalItems: storage.artsTotal,
          percent: (storage.totalUsage > 0) ? (storage.artsUsage / storage.totalUsage) * 100 : 0.0,
        ),
        const SizedBox(height: 12),
        _buildCategoryItem(
          context: context,
          color: _snapsColor,
          title: "Fotos book",
          usage: storage.snapsUsage,
          totalItems: storage.snapsTotal,
          percent: (storage.totalUsage > 0) ? (storage.snapsUsage / storage.totalUsage) * 100 : 0.0,
        ),
        const SizedBox(height: 12),
        _buildCategoryItem(
          context: context,
          color: _docsColor,
          title: "Documentos",
          usage: storage.docsUsage,
          totalItems: storage.docsTotal,
          percent: (storage.totalUsage > 0) ? (storage.docsUsage / storage.totalUsage) * 100 : 0.0,
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red[400]),
            const SizedBox(width: 8),
            Text(
              "Lixeira: 0 B",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {

          },
          icon: const Icon(Icons.delete_forever, size: 18),
          label: const Text("Esvaziar lixeira"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCC3333), 
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildCategoryItem({

    required BuildContext context,
    required Color color,
    required String title,
    required int usage,
    required int totalItems,
    required double percent,
  }) {

    final ThemeData theme = Theme.of(context);
    final Color textSecondaryColor = theme.textTheme.bodySmall?.color ?? Colors.grey[600]!;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatBytes(usage),
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "$totalItems itens · ${percent.toStringAsFixed(1)}%",
              style: theme.textTheme.bodySmall?.copyWith(color: textSecondaryColor),
            ),
          ],
        ),
      ],
    );
  }
}