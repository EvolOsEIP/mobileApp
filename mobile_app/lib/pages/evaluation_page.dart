import 'package:flutter/material.dart';
import 'package:mobile_app/utils/actions_widgets.dart';
import 'package:mobile_app/utils/instructions_widgets.dart';
import 'package:mobile_app/services/evaluation_service.dart';
import 'package:mobile_app/utils/assistant.dart';

/// A stateful widget representing a evaluation page.
///
/// This page dynamically loads and displays evaluation steps
class EvaluationPage extends StatefulWidget {
  final dynamic evaluationId;

  /// Constructor requiring a [evaluationId] to load the respective evaluation data.
  const EvaluationPage({super.key, required this.evaluationId});

  @override
  _EvaluationPage createState() => _EvaluationPage();
}

class _EvaluationPage extends State<EvaluationPage> {
  dynamic dialogs;
  int life = 2;
  int currentDialogIndex = 0;
  double score = 0.0;
  String stepName = '';
  int allSteps = 0;
  int currentStep = 0;
  String instructionDescription = '';
  List<Map<String, dynamic>> widgetInstructions = [];
  List<Map<String, dynamic>> widgetActions = [];


  /// Flag to check if data has been loaded.
  bool isDataLoaded = false;

  final EvaluationService _evaluationService = EvaluationService();

  Future<void> loadData() async {
    try {
      List<dynamic> jsonData = await _evaluationService.fetchSteps(widget.evaluationId);

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
        // score update here
      });
      loadData();
    } else {
      _showCompletionDialog();
      // push the final score
    }
  }

  /// Displays a pop-up when the evaluation is completed.
  ///
  /// The pop-up shows a completion message from the evaluation content and redirects to the evaluations list.
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Evaluation"),
        content: Text("Féliciation tu as terminé ton eval."), //use var to load the correct msg
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
        title: const Text('Evaluation',style: TextStyle(color: Colors.black, fontSize: 20)),
        actions: [Padding(padding: const EdgeInsets.only(right: 20.0), child: buildStars(50))],
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
                          Row (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Espace entre les deux éléments
                            children: [
                              Text(
                                  stepName,
                                  style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)
                              ),
                              buildHeart(life)
                            ]
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
            nextStep: nextStep,
            score: score);
      default:
        return const SizedBox(); // Widget vide si type inconnu
    }
  }

  Widget buildStars(int score) {
    int stars = 0;
    if (score >= 51.0 && score <= 80.0) {
      stars = 2;
    } else if (score > 80.0) {
      stars = 3;
    } else if (score >= 40.0) {
      stars = 1;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget buildHeart(int life) {
    IconData heartIcon;

    if (life == 2) {
      heartIcon = Icons.favorite;
    } else if (life == 1) {
      // heartIcon = Icons.favorite_half;
      heartIcon = Icons.favorite_border;
    } else {
      heartIcon = Icons.favorite_border;
    }
    return Icon(heartIcon, color: Colors.red, size: 30);
  }
}
