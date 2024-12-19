import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String deviceInfo = "Device info will appear here.";
  String? _imagePath;

  // Fetch device info using Digest Authentication
  Future<void> fetchDeviceInfo() async {
    final username = 'admin'; // Replace with your Hikvision username
    final password = 'abc@1234'; // Replace with your Hikvision password
    final deviceIP = '192.168.1.100'; // Replace with your Hikvision device IP
    final url = 'http://$deviceIP/ISAPI/System/deviceInfo';

    final client = DigestAuthClient(username, password);

    try {
      final response = await client.get(Uri.parse(url));
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        setState(() {
          deviceInfo = jsonDecode(response.body).toString();
        });
      } else {
        setState(() {
          deviceInfo =
              'Error: Unable to fetch data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        deviceInfo = 'Error: $e';
      });
    }
  }

  // Pick an image using FilePicker
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _imagePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
      setState(() {
        _imagePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info & Image Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchDeviceInfo,
              child: const Text('Fetch Device Info'),
            ),
            const SizedBox(height: 20),
            Text(deviceInfo, textAlign: TextAlign.center),
            const Divider(height: 40, thickness: 2),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick an Image'),
            ),
            if (_imagePath != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Image.file(
                    File(_imagePath!),
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  Text("Path: $_imagePath"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
