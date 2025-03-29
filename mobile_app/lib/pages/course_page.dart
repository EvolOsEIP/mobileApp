import 'package:flutter/material.dart';
import 'package:mobile_app/utils/actions_widgets.dart';
import 'package:mobile_app/utils/instructions_widgets.dart';
import 'package:mobile_app/services/course_service.dart';
import 'package:mobile_app/utils/assistant.dart';

/// A stateful widget representing a course page.
///
/// This page dynamically loads and displays course steps
class CoursePage extends StatefulWidget {
  final dynamic courseId;

  /// Constructor requiring a [courseId] to load the respective course data.
  const CoursePage({super.key, required this.courseId});

  @override
  _CoursePage createState() => _CoursePage();
}

class _CoursePage extends State<CoursePage> {
  dynamic dialogs;
  int currentDialogIndex = 0;

  String stepName = '';
  int allSteps = 0;
  int currentStep = 0;
  String instructionDescription = '';
  List<Map<String, dynamic>> widgetInstructions = [];
  List<Map<String, dynamic>> widgetActions = [];


  /// Flag to check if data has been loaded.
  bool isDataLoaded = false;

  final CourseService _courseService = CourseService();

  Future<void> loadData() async {
    try {
      List<dynamic> jsonData = await _courseService.fetchSteps(widget.courseId);

      if (jsonData.isNotEmpty) {
        Map<String, dynamic> step = jsonData[currentStep];
        setState(() {
          stepName = step["title"] ?? "";
          instructionDescription = step["instructions"] ?? "";
          widgetInstructions = List<Map<String, dynamic>>.from(
              step["widgets"]["instructions"] ?? []);
          widgetActions =
              List<Map<String, dynamic>>.from(step["widgets"]["actions"] ?? []);
          allSteps = jsonData.length;
          dialogs = step["dialogs"] ?? [];
          isDataLoaded = true;
        });
      }
    } catch (e) {
      print("Erreur lors du chargement des données : $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isDataLoaded) {
      loadData();
    }
  }

  /// Moves to the next step if available, otherwise shows the completion dialog.
  void nextStep() {
    if (currentStep < allSteps - 1) {
      setState(() {
        currentStep++;
      });
      loadData();
    } else {
      _showCompletionDialog();
    }
  }

  /// Displays a pop-up when the course is completed.
  ///
  /// The pop-up shows a completion message from the course content and redirects to the courses list.
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cours complété"),
        content: Text("Féliciation tu as terminé ton cours."), //use var to load the correct msg
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/roadmap');
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Cours',
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
                      LinearProgressIndicator(value: currentStep / allSteps),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: displayWidget(instruction, context),
                                  ),
                                const SizedBox(height: 16.0),
                                for (var action in widgetActions)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: displayWidget(action, context),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (dialogs != null && dialogs.isNotEmpty)
                    Positioned.fill(
                      child: Assistant(
                        dialogs: dialogs,
                        onComplete: () {
                          setState(() {
                            dialogs = [];
                          });
                        },
                      ),
                    ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  /// Displays a widget based on its type.
  ///
  /// Supports "image" and "input_text" widgets. Returns an empty widget for unknown types.
  Widget displayWidget(Map<String, dynamic> widgetData, BuildContext context) {
    switch (widgetData["type"]) {
      case "image":
        return imageWidget(
            context, widgetData["data"], widgetData["description"]);
      case "input_text":
        return InputTextWidget(
          expectedValue: widgetData["expected_value"],
          description: widgetData["description"],
          nextStep: nextStep);
      default:
        return const SizedBox(); // Widget vide si type inconnu
    }
  }
}
