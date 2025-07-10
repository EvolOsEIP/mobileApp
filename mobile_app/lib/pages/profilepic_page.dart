import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/services/api_service.dart';
import 'dart:convert';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // pour MediaType
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({Key? key}) : super(key: key);
  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? profilePicUrl = "";

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      
    }
  }

  Future<File?> _uploadImage(BuildContext context) async {
    if (_imageFile == null) 
     return null;

    final cachingService = CachingStorageService();
    final token = await cachingService.getFromCache("token");
    String apiUrl = dotenv.env["HOST_URL"].toString() 
    ?? String.fromEnvironment('HOST_URL');

    final uri = Uri.parse(
        'http://' + apiUrl + '/upload/image');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          _imageFile!.path,
          contentType:
              MediaType.parse(lookupMimeType(_imageFile!.path) ?? 'image/jpeg'),
        ),
      );

    try {
      final response = await request.send();
      final resBody = await http.Response.fromStream(response);

      if (resBody.statusCode >= 200 && resBody.statusCode < 300) {
        final decoded = jsonDecode(resBody.body);
        profilePicUrl = decoded['filename'];
        print("decoded: $decoded");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image envoyée avec succès !")),
        );
        return _imageFile; // Retourne le fichier image
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur serveur: ${resBody.statusCode}")),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi: $e")),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajoute ta photo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? const Icon(Icons.person, size: 80, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera, context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Caméra"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery, context),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Galerie"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_imageFile != null && _imageFile!.path.isNotEmpty) {
                  await _uploadImage(context);
                } 
                ApiService apiService = ApiService();
                if (profilePicUrl == null || profilePicUrl!.isEmpty) {
                    Navigator.pushReplacementNamed(context, '/roadmap');
                }
                apiService.put(
                  'profile/me/profile-pic',
                  {
                    "profilePicUrl": profilePicUrl,
                  },
                ).then((response) async {
                  if (response.isNotEmpty) {
                    final tokenService = CachingStorageService();
                    final token = await tokenService.getFromCache('token');
                    print('token: $token');
                    fetchFromApi('/api/profile/me', headers: {
                      'Authorization': "Bearer " + token.toString()
                    }).then((response) {
                      if (response != null &&
                          !response.toString().contains('Forbidden')) {
                        print("Profile updated: $response");
                        tokenService.clearFromCache('profile');
                        tokenService.saveInCache(
                            jsonEncode(response), 'profile');
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Profil mis à jour avec succès !")),
                    );
                    Navigator.pushReplacementNamed(context, '/roadmap');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Erreur lors de la mise à jour du profil.")),
                    );
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Erreur lors de la mise à jour du profil: $error")),
                  );
                });
              },
              child: const Text("S'inscrire"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
