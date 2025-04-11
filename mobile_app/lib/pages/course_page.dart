import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/actions_widgets.dart';
import 'package:mobile_app/widgets/instructions_widgets.dart';
import 'package:mobile_app/services/course_service.dart';
import 'package:mobile_app/widgets/assistant.dart';

/// A stateful widget representing a course page.
///
/// This page dynamically loads and displays course steps, including
/// instructions and actions required for the user to progress through the course.
class CoursePage extends StatefulWidget {
  final dynamic courseId; ///< The ID of the course to load.

  /// Constructor requiring a [courseId] to load the respective course data.
  ///
  /// [courseId] is a unique identifier for the course whose steps and
  /// associated content will be fetched and displayed.
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

  /// Flag to check if course data has been loaded successfully.
  bool isDataLoaded = false;

  final CourseService _courseService = CourseService();

  /// Loads the course data and updates the state with the appropriate content.
  ///
  /// This function fetches the course steps from a service and updates the UI
  /// accordingly. It loads the step name, instructions, and any associated
  /// widgets such as instructions and actions.
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
      print("Error occurred during the courses data loading : $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Load data only if it has not been loaded yet.
    if (!isDataLoaded) {
      loadData();
    }
  }

  /// Moves to the next step of the course if available.
  ///
  /// If there are more steps, it increments the current step index
  /// and loads the next step. If the course has been completed, it shows
  /// a completion dialog.
  ///
  /// [life] can be used for managing lives or other gameplay elements, if applicable.
  void nextStep(int? life) {
    if (currentStep < allSteps - 1) {
      setState(() {
        currentStep++;
      });
      loadData();
    } else {
      _showCompletionDialog();
    }
  }

  /// Displays a pop-up dialog when the course is completed.
  ///
  /// The dialog displays a congratulatory message and provides an option
  /// to navigate back to the courses list or roadmap.
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cours complété"),
        content: Text("Félicitation tu as terminé ton cours."), //use var to load the correct msg
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
    return WillPopScope(
        onWillPop: () async {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quitter ?"),
          content: const Text("Tu vas perdre ta progression..."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Quitter")),
          ],
        ),
      ) ?? false;
    },
    child : Scaffold(
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
                // Display progress bar based on the current step
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
                          // Display the current step title
                          Text(
                            stepName,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // Display the instructions for the current step
                          Text(
                            instructionDescription,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20.0),
                          // Display instructions widgets
                          for (var instruction in widgetInstructions)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0),
                              child: displayWidget(instruction, context),
                            ),
                          const SizedBox(height: 16.0),
                          // Display action widgets
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
            // Display assistant if there are dialogs
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
    ),);
  }

  /// Displays a widget based on its type.
  ///
  /// This function supports displaying different types of widgets based
  /// on the type defined in the widget data (e.g., "image", "input_text").
  ///
  /// [widgetData] is a map containing the widget's data (e.g., type, description, etc.).
  /// [context] is the current build context of the widget.
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
        return const SizedBox(); // Return an empty widget for unknown types
    }
  }
}