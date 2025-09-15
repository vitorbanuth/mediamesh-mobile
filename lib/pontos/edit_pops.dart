import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pop.dart';
import 'dart:convert';

class EditPops extends StatefulWidget {
  final Ponto ponto;

  const EditPops({Key? key, required this.ponto}) : super(key: key);

  @override
  State<EditPops> createState() => _EditPopsState();
}

class _EditPopsState extends State<EditPops> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController faceDescriptionController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? selectedUnity;
  String? selectedType;
  String? selectedOrientation;
  String? selectedMaterial;
  String? selectedFacePosition;
  //String? selectedLightning;

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
    "Neutra": "NEUTRAL",
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
  };

  //final Map<String, dynamic> locationsMap = {
   // "type": "Point",
   // "coordinates": [0, 0],
 // };

  Future<void> updatePonto({
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
    //required String lightning,
  }) async {
    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/pops/${widget.ponto.unique}'),
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
       // "lightSource": lightning,
        "dimensions": dimensionsMap,
       // "location": locationsMap, COLOCAR UNIQUE E ID
      }),
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      print(response.body);
      throw Exception('Falha ao atualizar ponto: ${response.body}');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.ponto.name;
    referenceController.text = widget.ponto.reference;
    addressController.text = widget.ponto.address;
    faceDescriptionController.text = widget.ponto.faceDescription;
    widthController.text = widget.ponto.dimensions.width.toString();
    heightController.text = widget.ponto.dimensions.height.toString();
    selectedUnity = widget.ponto.dimensions.unit;
    
    // Invertendo os mapas para preencher os dropdowns
    selectedType = kindMap.entries.firstWhere((e) => e.value == widget.ponto.kind, orElse: () => const MapEntry("", "")).key;
    selectedOrientation = orientationMap.entries.firstWhere((e) => e.value == widget.ponto.orientation, orElse: () => const MapEntry("", "")).key;
    selectedMaterial = materialMap.entries.firstWhere((e) => e.value == widget.ponto.material, orElse: () => const MapEntry("", "")).key;
    selectedFacePosition = facePositionMap.entries.firstWhere((e) => e.value == widget.ponto.facePosition, orElse: () => const MapEntry("", "")).key;
    // selectedLightning = ... (precisa do campo correspondente no modelo 'Ponto')
  }

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
        title: const Text("Editar Ponto"),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome do ponto", border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? "Preencha o nome do ponto" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: referenceController,
                decoration: const InputDecoration(labelText: "Referência", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Endereço", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: faceDescriptionController,
                decoration: const InputDecoration(labelText: "Descritivo da face", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: widthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Largura", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Altura", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUnity,
                decoration: const InputDecoration(labelText: "Selecione uma unidade", border: OutlineInputBorder()),
                items: ['cm', 'm'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedUnity = val),
                validator: (val) => val == null ? "Escolha uma unidade" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: "Selecione um tipo", border: OutlineInputBorder()),
                items: ['Outdoor', 'Indoor', 'Elevador'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedType = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedOrientation,
                decoration: const InputDecoration(labelText: "Selecione uma orientação", border: OutlineInputBorder()),
                items: ['Vertical', 'Horizontal', 'Neutra'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedOrientation = val),
                validator: (val) => val == null ? "Escolha uma orientação" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                decoration: const InputDecoration(labelText: "Selecione um material", border: OutlineInputBorder()),
                items: ['Estático', 'Digital', 'Vinil'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedMaterial = val),
                validator: (val) => val == null ? "Escolha um material" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedFacePosition,
                decoration: const InputDecoration(labelText: "Selecione a posição da face", border: OutlineInputBorder()),
                items: ['Frontal', 'Lateral', 'Em Ângulo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedFacePosition = val),
                validator: (val) => val == null ? "Escolha uma posição" : null,
              ),
              const SizedBox(height: 16),
             //DropdownButtonFormField<String>(
               // value: selectedLightning,
                //decoration: const InputDecoration(labelText: "Selecione a iluminação", border: OutlineInputBorder()),
                //items: ['Direta (Refletor)', 'Interna (Backlight)', 'Nenhuma'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                //onChanged: (val) => setState(() => selectedLightning = val),
               // validator: (val) => val == null ? "Escolha uma iluminação" : null,
            //  ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if (selectedUnity == null || selectedType == null || selectedOrientation == null || 
                          selectedMaterial == null || selectedFacePosition == null) {
                        throw Exception("Preencha todos os campos obrigatórios.");
                      }

                      await updatePonto(
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
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ponto atualizado com sucesso!")),
                      );
                      Navigator.pop(context, true); // Retorna true para indicar sucesso
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
                    }
                  }
                },
                child: const Text("Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
