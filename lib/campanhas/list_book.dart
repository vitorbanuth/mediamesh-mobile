import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class ListBook extends StatefulWidget {
  final String cmpgnUnq;
  const ListBook({super.key, required this.cmpgnUnq});

  @override
  State<ListBook> createState() => _ListBookState();
}

class _ListBookState extends State<ListBook> {
  PdfController? _pdfController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final url = Uri.parse('https://sinestro.mediamesh.com.br/storage/campaigns/${widget.cmpgnUnq}/books/book?view=true');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      _pdfController = PdfController(
        document: PdfDocument.openData(response.bodyBytes),
      );
      setState(() {});
    } else {
      print('Erro ao carregar PDF: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pdfController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Visualizar PDF')),
      body: PdfView(
        controller: _pdfController!,
      ),
    );
  }
}
