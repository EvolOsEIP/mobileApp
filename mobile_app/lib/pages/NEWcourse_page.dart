import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePage createState() => _CoursePage();

}

class _CoursePage extends State<CoursePage> {
  String stepName = '';
  int stepId = 0;
  int allSteps = 0;
  String instructionDescription = '';
  List<Map<String, dynamic>> widgetInstructions = [];
  List<Map<String, dynamic>> widgetActions = [];

  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Charger le fichier JSON
      String jsonString = await rootBundle.loadString('mobile_app/assets/courses_page_exemple.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        stepName = jsonData["step_name"] ?? '';
        stepId = jsonData["step_id"] ?? 0;
        allSteps = jsonData["all_steps"] ?? 1;
        instructionDescription = jsonData["instruction_description"] ?? '';
        widgetInstructions = List<Map<String, dynamic>>.from(jsonData["widget_instructions"] ?? []);
        widgetActions = List<Map<String, dynamic>>.from(jsonData["widget_actions"] ?? []);
        isDataLoaded = true;
      });
    } catch (e) {
      print("Erreur lors du chargement des données : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Chapters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: isDataLoaded
          ? SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                LinearProgressIndicator(value: stepId / allSteps),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stepName,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            instructionDescription,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20.0),
                          for (var instruction in widgetInstructions)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: displayWidget(instruction),
                            ),
                          const SizedBox(height: 16.0),
                          for (var action in widgetActions)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: displayWidget(action),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
  Widget displayWidget(Map<String, dynamic> widgetData) {
    switch (widgetData["type"]) {
      case "image":
        return imageWidget(widgetData["data"], widgetData["description"]);
      case "input_text":
        return inputTextWidget(widgetData["expected_value"], widgetData["description"]);
      default:
        return const SizedBox(); // Widget vide si type inconnu
    }
  }

  Widget imageWidget(String imagePath, String description) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget inputTextWidget(String expectedValue, String description) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Entrez votre réponse ici...",
          ),
          onSubmitted: (value) {
            if (value == expectedValue) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bonne réponse ! 🎉"))
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mauvaise réponse. Réessayez ! ❌"))
              );
            }
          },
        ),
      ],
    );
  }
}