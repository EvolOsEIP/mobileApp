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
  int currentStep = 0;
  int age = 30;
  String language = 'Français';
  bool usedDevice = false;
  List<String> skills = [];
  List<String> difficulties = [];
  List<String> goals = [];
  List<String> accessibility = [];
  int xpState = 0;

  final _ageController = TextEditingController(text: '30');

  final skillOptions = ['Passer un appel', 'Envoyer un message', 'Naviguer sur Internet'];
  final difficultyOptions = ['Lire l’écran', 'Utiliser les petits boutons', 'Comprendre les menus'];
  final goalOptions = ['Utiliser WhatsApp', 'Faire une démarche en ligne', 'Envoyer un mail'];
  final accessibilityOptions = ['Texte agrandi', 'Aide audio'];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < 7) {
      setState(() {
        currentStep++;
      });
    } else {
      submitForm(context);
    }
  }

  void toggleSelection(String item, List<String> targetList) {
    setState(() {
      if (targetList.contains(item)) {
        targetList.remove(item);
      } else {
        targetList.add(item);
      }
    });
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
      'language': language
      // 'skills': skills,
      // 'difficulties': difficulties,
      // 'goals': goals,
      // 'accessibility': accessibility,
    }, {}).then((response) async {
      if (response != null && response.toString().contains('success')) {
        final tokenService = CachingStorageService();
        await tokenService.saveInCache(response['token'], 'token');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePicturePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création de votre compte.')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
    });
  }

  Widget buildStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          children: [
            Text("Quel est votre âge ?", style: _titleStyle()),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Âge', border: OutlineInputBorder()),
            )
          ],
        );
      case 1:
        return Column(
          children: [
            Text("Langue préférée", style: _titleStyle()),
            DropdownButtonFormField<String>(
              value: language,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ['Français']
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (value) => setState(() => language = value!),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            Text("A quelle fréquence utilisez vous un appareil ?", style: _titleStyle()),
            Slider(
              value: xpState.toDouble(),
              onChanged: (value) => setState(() => xpState = value.toInt()),
              min: 0,
              max: 2,
              divisions: 2,
              label: ['Jamais', 'Occasionnellement', 'Régulièrement'][xpState],
              activeColor: CustomColors.primary,
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
              "De quelle aide aurez-vous besoin ?",
              style: _titleStyle().copyWith(fontSize: 30, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            CheckboxListTile(
              title: const Text("Aide audio"),
              value: usedDevice,
              onChanged: (value) => setState(() => usedDevice = value ?? false),
            ),
            SizedBox(height: 30),
            Text("Taille de texte"),
             Slider(
              value: xpState.toDouble(),
              onChanged: (value) => setState(() => xpState = value.toInt()),
              min: 0,
              max: 2,
              divisions: 2,
              label: ['petit', 'moyen', 'gros'][xpState],
              activeColor: CustomColors.primary,
            ),
            
          ],
        );
      case 4:
        return _buildCheckboxStep("Que savez-vous déjà faire ?", skillOptions, skills);
      case 5:
        return _buildCheckboxStep("Qu’est-ce qui est difficile pour vous ?", difficultyOptions, difficulties);
      case 6:
        return _buildCheckboxStep("Qu’aimeriez-vous apprendre ?", goalOptions, goals);
      case 7:
        return Column(
          children: [
            const Text("Tout est prêt !", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Appuyez sur terminer pour valider votre inscription."),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildCheckboxStep(String title, List<String> options, List<String> targetList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
              title,
              style: _titleStyle().copyWith(fontSize: 30, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              ),
            ),
        // Text(title, style: _titleStyle()),
        ...options.map((option) => CheckboxListTile(
          title: Text(option),
          value: targetList.contains(option),
          onChanged: (_) => toggleSelection(option, targetList),
        )),
      ],
    );
  }

  TextStyle _titleStyle() =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.dark_accent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenue"),
        backgroundColor: CustomColors.dark_accent,
      ),
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      Expanded(
        child: Center( // <-- Ajout ici pour centrer verticalement
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: buildStepContent(),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.accent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          currentStep < 7 ? "Suivant" : "Terminer",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  ),
),

    );
  }
}

