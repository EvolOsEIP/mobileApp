import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobile_app/utils/actionsWidgets.dart';
import 'package:mobile_app/utils/instructionsWidgets.dart';

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
      String jsonString = await rootBundle.loadString('assets/courses_page_example.json');
      List<dynamic> jsonData = jsonDecode(jsonString);

      if (jsonData.isNotEmpty) {
        Map<String, dynamic> step = jsonData[0]; // l'id de la page /step

        setState(() {
          print("set state");
          stepId = step["step_id"] ?? 0;
          allSteps = step["all_steps"] ?? 1;
          stepName = step["step_name"] ?? "";
          instructionDescription = step["instruction"] ?? "";
          widgetInstructions = List<Map<String, dynamic>>.from(step["widgets"]["instructions"] ?? []);
          widgetActions = List<Map<String, dynamic>>.from(step["widgets"]["actions"] ?? []);
          isDataLoaded = true;
        });
      }
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
                              child: displayWidget(instruction, context),
                            ),
                          const SizedBox(height: 16.0),
                          for (var action in widgetActions)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: displayWidget(action, context),
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

  Widget displayWidget(Map<String, dynamic> widgetData, BuildContext context) {
    print('Display un widget : $widgetData');
    switch (widgetData["type"]) {
      case "image":
        return imageWidget(context, widgetData["data"], widgetData["description"]);
      case "input_text":
        return inputTextWidget(context, widgetData["expected_value"], widgetData["description"]);
      default:
        return const SizedBox(); // Widget vide si type inconnu
    }
  }
}