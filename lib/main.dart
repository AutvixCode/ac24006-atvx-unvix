// ignore_for_file: type=lint

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'controllers/server.dart';
import 'widgets/dialog.dart';
import 'package:unity_importer/controllers/global_variables.dart';
import 'package:http/http.dart' as http;

void main() {
  startServer(); // Inicie o servidor
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileUploadScreen(),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  Uint8List? selectedFileBytes; // Armazena os bytes do arquivo
  String? selectedFileName; // Armazena o nome do arquivo

  void _dialog() {
    showDialog(
      context: context,
      builder: (context) => SlideIndex(0),
    );
  }

  void _uploadFile() async {
    if (selectedFileBytes != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://localhost:8080/upload'));

      request.files.add(
          http.MultipartFile.fromBytes('fbxFile', selectedFileBytes!, filename: selectedFileName));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Arquivo enviado com sucesso!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Falha ao enviar o arquivo: ${response.reasonPhrase}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao enviar o arquivo: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhum arquivo selecionado.')));
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['fbx'],
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedFileBytes = result.files.single.bytes; // Armazena os bytes do arquivo
        selectedFileName = result.files.single.name; // Armazena o nome do arquivo
        print("Arquivo selecionado: $selectedFileName");
      });
    } else {
      print("Nenhum arquivo selecionado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black26, Colors.black87],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    iconUnivix,
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _dialog,
                          child: SvgPicture.asset(
                            iconInfo,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('Selecione um Arquivo',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(selectedFileBytes != null
                        ? 'Arquivo selecionado: $selectedFileName'
                        : 'Nenhum arquivo selecionado'),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _uploadFile,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                            child: Text(
                              'Enviar Arquivo',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
