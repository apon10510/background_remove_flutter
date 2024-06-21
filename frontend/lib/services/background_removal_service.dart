// import 'dart:io';
// import 'package:http/http.dart' as http;
// // import 'package:path/path.dart';

// class BackgroundRemovalService {
//   final String baseUrl = 'http://10.0.2.2:5000';

//   Future<File?> removeBackground(File image) async {
//     final url = Uri.parse('$baseUrl/remove_background');
//     var request = http.MultipartRequest('POST', url);
//     request.files.add(await http.MultipartFile.fromPath('image', image.path));

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       final bytes = await response.stream.toBytes();
//       final tempDir = Directory.systemTemp;
//       final tempFile = File('${tempDir.path}/processed_image.png');
//       await tempFile.writeAsBytes(bytes);
//       return tempFile;
//     } else {
//       return null;
//     }
//   }
// }