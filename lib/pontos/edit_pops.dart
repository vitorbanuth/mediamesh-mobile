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
  final TextEditingController uniqueController = TextEditingController();
  final TextEditingController idController = TextEditingController();
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



  Future<void> updatePonto({
    required String id,
    required String unique,
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
    required dynamic lightning, // mesmo tipo que você usa no NewPops
  }) async {
    final int? widthValue = int.tryParse(width);
    final int? heightValue = int.tryParse(height);
    if (widthValue == null || heightValue == null) {
      throw Exception("Largura/Altura inválidas.");
    }

    final dimensionsMap = {
      "width": widthValue,
      "height": heightValue,
      "unit": unit,
      // preserva se o backend validar esses campos
      "artWidth": widget.ponto.dimensions.artWidth,
      "artHeight": widget.ponto.dimensions.artHeight,
    };

    final locationsMap = {
      "type": widget.ponto.location.type,
      "coordinates": widget.ponto.location.coordinates,
    };

    final payload = {
      // obrigatórios segundo o stakeholder
      "id": id,          // se o backend exigir "_id", troque a chave aqui
      "unique": unique,

      // mesmo shape do criar ponto
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
    };

    final response = await http.post(
      Uri.parse('https://sinestro.mediamesh.com.br/api/pops/$unique'),
      headers: const {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Cookie': 'sid=s%3Aj%3A%7B%22id%22%3A%22PAQQE22U%22%2C%22apiVersion%22%3A%22939fb3ae%22%2C%22tenant%22%3A%7B%22alias%22%3A%22devs%22%2C%22taxId%22%3A%2293564144000151%22%2C%22slug%22%3A%22devs%22%7D%2C%22user%22%3A%7B%22unique%22%3A%224M7KC7FC%22%2C%22name%22%3A%22Devs%22%2C%22email%22%3A%22devs%40mediamesh.com.br%22%2C%22hasSetup%22%3Atrue%7D%7D.lAiHBJzBPbp4cKvKqPBx3%2FX72AQ615XeRIFxKO2bHoE'
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint("URL: https://sinestro.mediamesh.com.br/api/pops/$unique");
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");
      throw Exception('Falha ao atualizar ponto (${response.statusCode}).');
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? _keyForValue(Map<String, String> map, String value) {
    for (final e in map.entries) {
      if (e.value == value) return e.key;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    uniqueController.text = widget.ponto.unique;
    idController.text = widget.ponto.id;
    nameController.text = widget.ponto.name;
    referenceController.text = widget.ponto.reference;
    addressController.text = widget.ponto.address;
    faceDescriptionController.text = widget.ponto.faceDescription;
    widthController.text = widget.ponto.dimensions.width.toString();
    heightController.text = widget.ponto.dimensions.height.toString();
    selectedUnity = widget.ponto.dimensions.unit;

    selectedType = _keyForValue(kindMap, widget.ponto.kind);
    selectedOrientation = _keyForValue(orientationMap, widget.ponto.orientation);
    selectedMaterial = _keyForValue(materialMap, widget.ponto.material);
    selectedFacePosition = _keyForValue(facePositionMap, widget.ponto.facePosition);
  }

  @override
  void dispose() {
    uniqueController.dispose();
    idController.dispose();
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
                validator: (v) => (int.tryParse(v?.trim() ?? '') == null) ? "Informe um número válido" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Altura", border: OutlineInputBorder()),
                validator: (v) => (int.tryParse(v?.trim() ?? '') == null) ? "Informe um número válido" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUnity,
                decoration: const InputDecoration(labelText: "Unidade", border: OutlineInputBorder()),
                items: ['cm', 'm'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedUnity = val),
                validator: (v) => v == null ? "Selecione uma unidade" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: "Tipo", border: OutlineInputBorder()),
                items: ['Outdoor', 'Indoor', 'Elevador'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedType = val),
                validator: (v) => v == null ? "Selecione um tipo" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedOrientation,
                decoration: const InputDecoration(labelText: "Orientação", border: OutlineInputBorder()),
                items: ['Vertical', 'Horizontal', 'Neutra'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedOrientation = val),
                validator: (v) => v == null ? "Selecione uma orientação" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                decoration: const InputDecoration(labelText: "Material", border: OutlineInputBorder()),
                items: ['Estático', 'Digital', 'Vinil'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedMaterial = val),
                validator: (v) => v == null ? "Selecione um material" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedFacePosition,
                decoration: const InputDecoration(labelText: "Posição da face", border: OutlineInputBorder()),
                items: ['Frontal', 'Lateral', 'Em Ângulo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedFacePosition = val),
                validator: (v) => v == null ? "Selecione a posição da face" : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await updatePonto(
                        id: idController.text,
                        unique: uniqueController.text,
                        name: nameController.text.trim(),
                        reference: referenceController.text.trim(),
                        address: addressController.text.trim(),
                        faceDescription: faceDescriptionController.text.trim(),
                        width: widthController.text.trim(),
                        height: heightController.text.trim(),
                        unit: selectedUnity!,
                        type: selectedType!,
                        orientation: selectedOrientation!,
                        material: selectedMaterial!,
                        facePosition: selectedFacePosition!,
                        lightning: null, // passe aqui o mesmo valor usado no NewPops
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ponto atualizado com sucesso!")),
                      );
                      Navigator.pop(context, true);
                    } catch (e) {
                      if (!mounted) return;
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