// ignore_for_file: type=lint, deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/dialog.dart';
import 'package:unity_importer/controllers/global_variables.dart';
import 'package:http/http.dart' as http;

void main() {
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

// Main screen for file upload
class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  Uint8List? selectedFileBytes;
  String? selectedFileName;

  // Function to show a dialog
  void _dialog() {
    showDialog(
      context: context,
      builder: (context) => SlideIndex(0),
    );
  }

  // Function to upload the selected file
  void _uploadFile() async {
    if (selectedFileBytes != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://172.27.90.203:8080/upload'));

      request.files.add(http.MultipartFile.fromBytes(
          'fbxFile', selectedFileBytes!,
          filename: selectedFileName));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File successfully uploaded! ${selectedFileName}')));

      await request.send();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No file selected.')));
    }
  }

  // Function to pick a file from the device
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['fbx'],
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedFileBytes = result.files.single.bytes;
        selectedFileName = result.files.single.name;
        print("Selected file: $selectedFileName");
      });
    } else {
      print("No file selected");
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
                          child: Text('Select a File',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(selectedFileBytes != null
                        ? 'Selected file: $selectedFileName'
                        : 'No file selected'),
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
                          'Upload File',
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
