// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/background_removal_service.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   File? _image;
//   File? _processedImage;
//   final BackgroundRemovalService _service = BackgroundRemovalService();

//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _processedImage = null;
//       });
//     }
//   }

//   Future<void> _removeBackground() async {
//     if (_image == null) return;

//     final processedImage = await _service.removeBackground(_image!);
//     if (processedImage != null) {
//       setState(() {
//         _processedImage = processedImage;
//       });
//     } else {
//       print('Failed to remove background');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ... (same as before)
//   }
// }