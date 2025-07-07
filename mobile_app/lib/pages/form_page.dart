import 'package:flutter/material.dart';
import 'package:mobile_app/pages/profilepic_page.dart';
import 'package:mobile_app/pages/register_page.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/utils/colors.dart';

class OnboardingForm extends StatefulWidget {
  final dynamic? userProfile;

  const OnboardingForm({Key? key, this.userProfile}) : super(key: key);

  @override
  _OnboardingFormState createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  int age = 30;
  String language = 'Français';
  bool usedDevice = false;
  List<String> skills = [];
  List<String> difficulties = [];
  List<String> goals = [];
  List<String> accessibility = [];

  final _ageController = TextEditingController(text: '30');

  final skillOptions = ['Passer un appel', 'Envoyer un message', 'Naviguer sur Internet'];
  final difficultyOptions = ['Lire l’écran', 'Utiliser les petits boutons', 'Comprendre les menus'];
  final goalOptions = ['Utiliser WhatsApp', 'Faire une démarche en ligne', 'Envoyer un mail'];
  final accessibilityOptions = ['Texte agrandi', 'Aide audio', 'Aide d’un proche'];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void submitForm(BuildContext context) {
    final parsedAge = int.tryParse(_ageController.text) ?? 30;
    setState(() => age = parsedAge);

    postToApi('/auth/register', {
      'username': widget.userProfile?['email'].toString().split('@')[0],
      'email': widget.userProfile?['email'],
      'password': widget.userProfile?['password'],
      'role': 'learner',
      'age': parsedAge.toString(),
      'language': language,
      'usedDevice': usedDevice.toString(),
      'skills': skills.toString(),
      'difficulties': difficulties.toString(),
      'goals': goals.toString(),
      'accessibility': accessibility.toString(),
    }, {}).then((response) async {
      if (response != null && response.toString().contains('success')) {
        print("token: ${response['token']}");
        final tokenService = CachingStorageService();
        await tokenService.saveInCache(response['token'], 'token');
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePicturePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
      }
    }).catchError((error) {
      fetchFromApi("api/profile/me").then((profile) {
        if (profile.toString().contains('success')) {
          if (profile['email'] == widget.userProfile?['email']) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePicturePage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de profil : ${profile['message']}')));
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création de votre compte.')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
    });
  }

  Widget buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.dark_accent),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue"),
        backgroundColor: CustomColors.dark_accent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSectionTitle("Quel est votre âge ?"),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Âge',
                border: OutlineInputBorder(),
              ),
            ),
            buildSectionTitle("Langue préférée"),
            DropdownButtonFormField<String>(
              value: language,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ['Français', 'Créole', 'Anglais', 'Arabe']
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (value) => setState(() => language = value!),
            ),
            buildSectionTitle("Avez-vous déjà utilisé un appareil ?"),
            SwitchListTile(
              title: Text(usedDevice ? "Oui" : "Non"),
              value: usedDevice,
              onChanged: (val) => setState(() => usedDevice = val),
              activeColor: CustomColors.accent,
            ),
            buildSectionTitle("Que savez-vous déjà faire ?"),
            ...skillOptions.map((option) => CheckboxListTile(
              title: Text(option),
              value: skills.contains(option),
              onChanged: (val) => setState(() {
                val! ? skills.add(option) : skills.remove(option);
              }),
              activeColor: CustomColors.primary,
            )),
            buildSectionTitle("Qu’est-ce qui est difficile pour vous ?"),
            ...difficultyOptions.map((option) => CheckboxListTile(
              title: Text(option),
              value: difficulties.contains(option),
              onChanged: (val) => setState(() {
                val! ? difficulties.add(option) : difficulties.remove(option);
              }),
              activeColor: CustomColors.primary,
            )),
            buildSectionTitle("Qu’aimeriez-vous apprendre ?"),
            ...goalOptions.map((option) => CheckboxListTile(
              title: Text(option),
              value: goals.contains(option),
              onChanged: (val) => setState(() {
                val! ? goals.add(option) : goals.remove(option);
              }),
              activeColor: CustomColors.primary,
            )),
            buildSectionTitle("Besoin d’une aide particulière ?"),
            ...accessibilityOptions.map((option) => CheckboxListTile(
              title: Text(option),
              value: accessibility.contains(option),
              onChanged: (val) => setState(() {
                val! ? accessibility.add(option) : accessibility.remove(option);
              }),
              activeColor: CustomColors.primary,
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.accent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Continuer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () => submitForm(context),
            )
          ],
        ),
      ),
    );
  }
}
