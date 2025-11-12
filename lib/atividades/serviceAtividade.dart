import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modelAtividade.dart';

Future<List<Activity>> fetchActivities() async {
  final response = await http.get(
    Uri.parse('https://sinestro.mediamesh.com.br/api/activities'),
    headers: {
      'Content-Type': 'application/json',
      // mantenha o cookie/token em local seguro (ex: storage). Aqui sigo seu padrão atual.
      'Cookie':
          'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Erro ao carregar activities (${response.statusCode})');
  }

  final decoded = jsonDecode(response.body);

  List<dynamic> lista;
  if (decoded is List) {
    lista = decoded;
  } else if (decoded is Map && decoded.containsKey('data')) {
    lista = decoded['data'];
  } else if (decoded is Map) {
    // A API pode devolver um objecto com array em outro campo; tentamos assumir que o body é um array único
    lista = [decoded];
  } else {
    throw Exception("Formato inesperado de resposta: ${decoded.runtimeType}");
  }

  return lista
      .map((e) => Activity.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}