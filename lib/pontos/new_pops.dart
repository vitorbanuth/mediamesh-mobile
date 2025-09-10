import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pop.dart';
import 'dart:convert';

class NewPops extends StatefulWidget {
  // final VoidCallback onPopCreated;

  // NewPops({Key? key, required this.onPopCreated}) : super(key: key);

  const NewPops({Key? key}) : super(key: key);

  @override
  State<NewPops> createState() => _NewPopsState();
}

class _NewPopsState extends State<NewPops> {
  // Controllers para capturar os valores dos campos
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController faceDescriptionController =
      TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? selectedUnity;
  String? selectedType;
  String? selectedOrientation;
  String? selectedMaterial;
  String? selectedFacePosition;
  String? selectedLightning;

  final Map<String, String> kindMap = {
    "Outdoor": "OUTDOOR",
    "Indoor": "INDOOR",
    "Elevador": "ELEVATOR",
  };

  final Map<String, String> materialMap = {
    "Estático": "PAPER",
    "Digital": "DIGITAL",
    "Vinil": "VINYL",
  };

  final Map<String, String> orientationMap = {
    "Vertical": "PORTRAIT",
    "Horizontal": "LANDSCAPE",
    "Neutro": "NEUTRAL",
  };

  final Map<String, String> facePositionMap = {
    "Frontal": "FRONT",
    "Lateral": "SIDE",
    "Em Ângulo": "ANGLE",
  };

  final Map<String, dynamic> dimensionsMap = {
    "width": 0,
    "height": 0,
    "artWidth": 0,
    "artHeight": 0,
    "unit": "m",
    "soilHeight": 0,
    "totalHeight": 0,
  };

  final Map<String, dynamic> locationsMap = {
    "type": "Point",
    "coordinates": [0, 0],
  };

  Future<Ponto> createPop({
    required String name,
    required String reference,
    required String address,
    required String faceDescription,
    required String width,
    required String height,
    required String unit,
    required String type,
    required String orientation,
    required String material,
    required String facePosition,
    required String lightning,
  }) async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/pops/new'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie':
            'sid=s%3Aj%3A%7B%22id%22%3A%229E4DQBPR%22%2C%22apiVersion%22%3A%22993fda5c%22%2C%22account%22%3A%7B%22taxId%22%3A%2210276433000128%22%2C%22alias%22%3A%22devs%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22name%22%3A%22Ksmz%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%7D%7D.ovxaACdIZDF7tU3Z%2BgPfGTJXdKP6QWWieeyi%2FbD5nms',
      },
      body: jsonEncode({
        "name": name,
        "kind": kindMap[type],
        "reference": reference,
        "address": address,
        "orientation": orientationMap[orientation],
        "material": materialMap[material],
        "facePosition": facePositionMap[facePosition],
        "faceDescription": faceDescription,
        "lightSource": lightning,
        "dimensions": dimensionsMap,
        "location": locationsMap,
      }),
    );

    if (response.statusCode == 200) {
      return Ponto.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao criar ponto: ${response.body}');
    }
  }

  // Chave para validação do formulário
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    widthController.dispose();
    heightController.dispose();
    referenceController.dispose();
    faceDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Ponto"),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nome
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nome do ponto",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Preencha o nome do ponto";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Referenia
              TextFormField(
                controller: referenceController,
                decoration: const InputDecoration(
                  labelText: "Referência",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Endereço
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Descritivo da face
              TextFormField(
                controller: faceDescriptionController,
                decoration: const InputDecoration(
                  labelText: "Descritivo da face",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Largura
              TextFormField(
                controller: widthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Largura",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Altura
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Altura",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // valor atual selecionado
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecione uma unidade",
                  border: OutlineInputBorder(),
                  iconColor: Colors.blueAccent,
                ),
                items: ['cm', 'm']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedUnity = val),
                validator: (val) => val == null ? "Escolha uma unidade" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecione um tipo",
                  border: OutlineInputBorder(),
                  iconColor: Colors.blueAccent,
                ),
                items: ['Outdoor', 'Indoor', 'Elevador']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecione uma orientação",
                  border: OutlineInputBorder(),
                  iconColor: Colors.blueAccent,
                ),
                items: ['Vertical', 'Horizontal', 'Neutra']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedOrientation = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecione um material",
                  border: OutlineInputBorder(),
                  iconColor: Colors.blueAccent,
                ),
                items: ['Estático', 'Digital', 'Vinil']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedMaterial = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecione a posição da face",
                  border: OutlineInputBorder(),
                  iconColor: Colors.blueAccent,
                ),
                items: ['Frontal', 'Lateral', 'Em Ângulo']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedFacePosition = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecione a iluminação",
                  border: OutlineInputBorder(),
                  iconColor: Colors.blueAccent,
                ),
                items: ['Direta (Refletor)', 'Interna (Backlight)', 'Nenhuma']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedLightning = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Botão salvar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final pontoCriado = await createPop(
                        name: nameController.text,
                        reference: referenceController.text,
                        address: addressController.text,
                        faceDescription: faceDescriptionController.text,
                        width: widthController.text,
                        height: heightController.text,
                        unit: selectedUnity!,
                        type: selectedType!,
                        orientation: selectedOrientation!,
                        material: selectedMaterial!,
                        facePosition: selectedFacePosition!,
                        lightning: selectedLightning!,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Ponto criado: ${pontoCriado.name}"),
                        ),
                      );
                      // widget.onPopCreated();
                      Navigator.pop(context, pontoCriado);
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                    }

                    // Volta para a tela anterior
                    // Navigator.pop(context);
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
