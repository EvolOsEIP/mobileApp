import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_app/utils/colors.dart';

// Composant Navbar
class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "Modules"),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favoris"),
      ],
    );
  }
}

// Page de profil
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Simule une réponse API
    String jsonResponse = '''
      {
        "name": "Sara Nguyen",
        "age": 27,
        "email": "sara.nguyen@toto.fr",
        "grade": "Conquérante",
        "progress": 10,
        "total": 10,
        "profilePic": "https://randomuser.me/api/portraits/women/45.jpg"
      }
    ''';
    setState(() {
      userData = json.decode(jsonResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.8;
    double profileImageSize = cardWidth * 0.3;

    return Scaffold(
      // Title

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: 20),
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(cardWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo + Infos Utilisateur
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: profileImageSize *
                            1, // <-- Réduit la largeur pour pousser le texte
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            userData["profilePic"],
                            width: profileImageSize,
                            height: profileImageSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                          width:
                              100), // <-- Augmente l’espace entre la photo et le texte
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData["name"],
                              style: TextStyle(
                                fontSize: cardWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${userData["age"]} ans",
                              style: TextStyle(
                                fontSize: cardWidth * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              userData["email"],
                              style: TextStyle(
                                fontSize: cardWidth * 0.035,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: cardWidth * 0.05),
                  // Mon grade
                  Center(
                    child: Text(
                      "Mon grade :",
                      style: TextStyle(
                        fontSize: cardWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events,
                          color: CustomColors.accent, size: cardWidth * 0.08),
                      const SizedBox(width: 8),
                      Text(
                        userData["grade"],
                        style: TextStyle(
                          fontSize: cardWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: cardWidth * 0.05),
                  // Pro
                  // Centgression
                  Center(
                    child: Text(
                      "Ma progression :",
                      style: TextStyle(
                        fontSize: cardWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: cardWidth * 0.2,
                      height: cardWidth * 0.2,
                      child: CircularProgressIndicator(
                        value: userData["progress"] / userData["total"],
                        backgroundColor: Colors.grey[300],
                        color: CustomColors.dark_accent,
                        strokeWidth: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "${userData["progress"]}/${userData["total"]}",
                      style: TextStyle(fontSize: cardWidth * 0.05),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Bouton "Mes succès obtenus"
                  Center(
                    child: SizedBox(
                      width: cardWidth * 0.6,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.accent,
                          padding: EdgeInsets.symmetric(
                            vertical: cardWidth * 0.04,
                            horizontal: cardWidth * 0.08,
                          ),
                        ),
                        child: Text(
                          "Mes succès obtenus",
                          style: TextStyle(
                              fontSize: cardWidth * 0.05, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
