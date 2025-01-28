import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  dynamic data;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getDatas() async {
    try {
      // Loads the JSON file as a string
      String dataString = await DefaultAssetBundle.of(context)
          .loadString('assets/chapters.json');

      // Parses the JSON string into a Dart object and updates the state
      setState(() {
        data = jsonDecode(dataString);
        // print(data);
      });
    } catch (e) {
      // Logs an error if the JSON file could not be loaded
      print("Error loading the JSON file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    getDatas(); // Fetches data when the widget is initialized
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.dark_accent,
        title: const Text(
          'Accueil',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    title: 'Profil',
                    icon: Icons.person,
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildCard(
                    title: 'Voir ma progression',
                    icon: Icons.bar_chart,
                    onTap: () {
                      Navigator.pushNamed(context, '/userprogress');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildCard(
              title: 'Voir la liste des modules',
              icon: Icons.list,
              onTap: () {
                Navigator.pushNamed(context, '/units');
              },
            ),
            const SizedBox(height: 20.0),
            _buildCard(
              title: 'Voir le cours 1',
              icon: Icons.book,
              onTap: () {
                Navigator.pushNamed(context, '/course_detail', arguments: {
                  'chapter': data["units"][0]["chapters"][0],
                  'index': 0
                }); //data["units"][0]["chapters"][0]["courses"][0]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: CustomColors.dark_accent),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
