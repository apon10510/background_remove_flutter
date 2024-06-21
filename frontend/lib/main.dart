import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Remover',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageBytes;
  Uint8List? _processedImageBytes;
  String? _imageName;
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _getImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageName = pickedFile.name;
          _processedImageBytes = null;
          _statusMessage = 'Image selected: ${pickedFile.name}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> _removeBackground() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Processing image...';
    });

    try {
      final url = Uri.parse('http://localhost:5000/remove_background');
      var request = http.MultipartRequest('POST', url);

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _imageBytes!,
        filename: _imageName ?? 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _processedImageBytes = response.bodyBytes;
          _statusMessage = 'Background removed successfully';
        });
      } else {
        throw Exception('Failed to remove background: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Background Remover')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageBytes != null)
                Image.memory(_imageBytes!, height: 200),
              if (_processedImageBytes != null)
                Image.memory(_processedImageBytes!, height: 200),
              SizedBox(height: 20),
              Text(_statusMessage),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _removeBackground,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Remove Background'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}