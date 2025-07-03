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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _uploadImage(BuildContext context) async {
  if (_imageFile == null) return;

  final cachingService = CachingStorageService();
  final token = await cachingService.getFromCache("token");

  final uri = Uri.parse('http://' + dotenv.env["HOST_URL"].toString() + '/upload/image');

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(
      await http.MultipartFile.fromPath(
        'file',
        _imageFile!.path,
        contentType: MediaType.parse(lookupMimeType(_imageFile!.path) ?? 'image/jpeg'),
      ),
    );

  try {
    final response = await request.send();
    final resBody = await http.Response.fromStream(response);

    if (resBody.statusCode >= 200 && resBody.statusCode < 300) {
      final decoded = jsonDecode(resBody.body);
      profilePicUrl = decoded['filename'];
      print(decoded);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image envoyée avec succès !")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur serveur: ${resBody.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors de l'envoi: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une photo de profil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Aperçu de la photo
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? Icon(Icons.person, size: 80, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 20),

            // Boutons de sélection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text("Caméra"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text("Galerie"),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Bouton d'envoi
            ElevatedButton(
              onPressed: _imageFile != null ? () => _uploadImage(context) : null,
              child: Text("Enregistrer la photo"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                  onPressed: () {
                      ApiService apiService = ApiService();
                      apiService.put(
                        'profile/me/profile-pic',
                        {
                          "profilePicUrl": profilePicUrl,
                        },
                      ).then((response) {
                        if (response.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Profil mis à jour avec succès !")),
                          );
                          final tokenService = CachingStorageService();
                          final token = tokenService.getFromCache('token');
                           fetchFromApi('/api/profile/me', headers: {
                            'Authorization': "Bearer " + token.toString()
                          }).then((response) {
                            if (response != null) {
                              tokenService.clearFromCache('profile');
                              tokenService.saveInCache(response.toString(), 'profile');
                          }});
                          Navigator.pushReplacementNamed(context, '/roadmap');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erreur lors de la mise à jour du profil.")),
                          );
                        }
                      });
                  },
                  child: const Text("S'inscrire"),
                )
          ],
        ),
      ),
    );
  }
}
