import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/utils/navbar.dart';

import 'settings_page.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  int age = 0;
  String language = "Français";
  String profileImageUrl = "default.png";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final cachingService = CachingStorageService();
    final cachedProfile = await cachingService.getFromCache('profile');

    if (cachedProfile != null) {
      final profile = jsonDecode(cachedProfile);
      setState(() {
        userName = profile['username'] ?? "Utilisateur";
        age = profile['age'] ?? 0;
        profileImageUrl = profile['profilepicurl'] ?? "default.png";
      });
    } else {
      final token = await cachingService.getFromCache('token');
      if (token != null) {
        final response = await fetchFromApi('/api/profile/me', headers: {
          'Authorization': "Bearer $token",
        });

        if (response != null) {
          await cachingService.saveInCache(jsonEncode(response), 'profile');
          setState(() {
            userName = response['name'] ?? "Utilisateur";
            age = response['age'] ?? 0;
            profileImageUrl = response['profilepicurl'] ?? "default.png";
          });
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage(context);
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_imageFile == null) return;

    final cachingService = CachingStorageService();
    final token = await cachingService.getFromCache("token");

    final uri = Uri.parse('http://${dotenv.env["HOST_URL"]}/upload/image');
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
        final filename = decoded['filename'];

        final putResponse = await ApiService().put(
          'profile/me/profile-pic',
          {"profilePicUrl": filename},
        );

        if (putResponse.isNotEmpty) {
          await cachingService.clearFromCache('profile');
          await _loadProfile();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Photo de profil mise à jour !")),
          );
        }
      } else {
        throw Exception("Erreur serveur: ${resBody.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi: $e")),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  final isDefaultImage = profileImageUrl == "default.png";
  final imageWidget = GestureDetector(
    onTap: () => _pickImage(ImageSource.gallery, context),
    child: CircleAvatar(
      radius: 50,
      backgroundImage: _imageFile != null
          ? FileImage(_imageFile!)
          : isDefaultImage
              ? AssetImage("assets/images/default.png") as ImageProvider
              : NetworkImage("http://${dotenv.env["HOST_URL"]}/api/images/$profileImageUrl"),
      child: Align(
        alignment: Alignment.bottomRight,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 15,
          child: Icon(Icons.edit, size: 18, color: Colors.teal),
        ),
      ),
    ),
  );

  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: RefreshIndicator(
      onRefresh: _loadProfile, // 👈 appel à ta fonction pour reload les données
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), // requis pour le pull même sans scroll long
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColors.dark_accent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(60),
              child: Column(
                children: [
                  imageWidget,
                  SizedBox(height: 10),
                  Text(userName,
                      style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Âge : $age", style: TextStyle(color: Colors.white70)),
                  Text("Langue : $language", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            SizedBox(height: 30),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Icon(Icons.settings, color: CustomColors.dark_accent),
                title: Text("Paramètres"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const Padding(
      padding: EdgeInsets.all(10.0),
      child: CustomNavbar(),
    ),
  );
}

}

