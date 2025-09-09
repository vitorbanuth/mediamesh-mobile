import 'package:flutter/material.dart';

class NewPops extends StatefulWidget {
  const NewPops({super.key});

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
  final TextEditingController unitController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController orientationController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController facePositionController = TextEditingController();
  final TextEditingController lightningController = TextEditingController();
  String? unidadeSelecionada;

  // Chave para validação do formulário
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // liberar os controllers quando o widget for destruído
    nameController.dispose();
    addressController.dispose();
    unitController.dispose();
    widthController.dispose();
    heightController.dispose();
    referenceController.dispose();
    faceDescriptionController.dispose();
    typeController.dispose();
    orientationController.dispose();
    materialController.dispose();
    facePositionController.dispose();
    lightningController.dispose();
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
                controller: addressController,
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
                controller: addressController,
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
                onChanged: (val) => setState(() => unidadeSelecionada = val),
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
                onChanged: (val) => setState(() => unidadeSelecionada = val),
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
                onChanged: (val) => setState(() => unidadeSelecionada = val),
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
                items: ['Estático', 'Digital']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => unidadeSelecionada = val),
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
                onChanged: (val) => setState(() => unidadeSelecionada = val),
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
                onChanged: (val) => setState(() => unidadeSelecionada = val),
                validator: (val) => val == null ? "Escolha um tipo" : null,

                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Botão salvar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO POST API BACKEND

                    // Volta para a tela anterior
                    Navigator.pop(context);
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
