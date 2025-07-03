import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'dart:convert';
import 'package:mobile_app/utils/navbar.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/fetchData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Chargement...";
  int age = 0;
  String language = "Inconnu";
  String profileImageUrl = "default.png";

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final cachingService = CachingStorageService();
    final cachedProfile = await cachingService.getFromCache('profile');
     cachingService.clearFromCache('profile');

    if (cachedProfile != null) {
      try {
        final profile = jsonDecode(cachedProfile);
        print("profile chargé depuis le cache : $profile");
        setState(() {
          userName = profile['username'] ?? "Utilisateur";
          age = profile['age'] ?? 0;
          language = profile['language'] ?? "Inconnu";
          profileImageUrl = profile['profilepicurl'] ?? 'default.png';
        });
      } catch (e) {
        print("Erreur de décodage du cache profil : $e");
      }
    } else {
      final token = await cachingService.getFromCache('token');
      if (token == null) {
        print("Aucun token trouvé.");
        return;
      }

      print("Chargement du profil depuis l'API...");
      final response = await fetchFromApi(
        '/api/profile/me',
        headers: {
          'Authorization': "Bearer $token",
          'context': context.toString(),
        },
      );

      if (response != null) {
        await cachingService.saveInCache(jsonEncode(response), 'profile');
        setState(() {
          userName = response['firstname'] ?? "Utilisateur";
          age = response['age'] ?? 0;
          language = response['language'] ?? "Inconnu";
          profileImageUrl = response['profilepicurl'] ?? 'default.png';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: CustomColors.dark_accent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(60),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImageUrl == 'default.png'
                      ? const AssetImage(
                          'assets/images/default.png') // chemin à adapter selon ton projet
                      : NetworkImage(
                          "http://${dotenv.env["HOST_URL"]}/api/images/$profileImageUrl",
                        ) as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text("Âge : $age",
                    style: const TextStyle(color: Colors.white70)),
                Text("Langue : $language",
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: const Icon(Icons.settings, color: Colors.teal),
              title: const Text("Paramètres"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(10.0),
        child: CustomNavbar(),
      ),
    );
  }
}
