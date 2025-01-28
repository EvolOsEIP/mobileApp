import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';

class UserProgress extends StatefulWidget {
  const UserProgress({super.key});

  @override
  State<UserProgress> createState() => _UserProgressState();
}

class _UserProgressState extends State<UserProgress> {
  final List<String> completedModules = [
    "Introduction à l'informatique",
    "Les bases du clavier et de la souris",
    "Naviguer sur Internet",
    "Créer et gérer un e-mail",
    "Sécurité et bonnes pratiques en ligne"
  ];

  String getEncouragementMessage() {
    int count = completedModules.length;
    if (count < 3) {
      return "Continue comme ça ! Chaque pas compte ! 🚀";
    } else if (count < 5) {
      return "Super progrès ! Tu es sur la bonne voie ! 🎯";
    } else {
      return "Incroyable ! Tu deviens un expert ! 🌟";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Ma Progression',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColors.dark_accent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Modules complétés",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: completedModules.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightGreen[100],
                    child: ListTile(
                      leading:
                          const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(completedModules[index],
                          style: const TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                getEncouragementMessage(),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
