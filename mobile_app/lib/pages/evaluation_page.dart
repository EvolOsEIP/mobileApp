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
  final dynamic score;

  /// Constructor requiring a [evaluationId] to load the respective evaluation data.
  const EvaluationPage({super.key, required this.evaluationId, required this.score});

  @override
  _EvaluationPage createState() => _EvaluationPage();
}

class _EvaluationPage extends State<EvaluationPage> {
  dynamic dialogs;
  int life = 2;
  double actualScore = 0;
  int currentDialogIndex = 0;
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
      life = 2;
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
  void nextStep(int life) {
    if (currentStep < allSteps - 1) {
      setState(() {
        if (life == 2) {
          actualScore += 1;
        } else if (life == 1) {
          actualScore += 0.5;
        }
        currentStep++;
        // score update here
      });
      loadData();
    } else {
      double finalScore = (actualScore / allSteps) * 100;
      //score to push in db
      _showCompletionDialog(finalScore);
    }
  }

  /// Displays a pop-up when the evaluation is completed.
  ///
  /// The pop-up shows a completion message from the evaluation content and redirects to the evaluations list.
  void _showCompletionDialog(double finalScore) {
    String message;
    int stars = 0;

    if (allSteps < 6) {
      if (finalScore >= allSteps - 1) {
        message = "Félicitations, tu as bien réussi ton évaluation !";
        stars = 3;
      } else if (finalScore >= allSteps / 2) {
        message = "Bon travail, tu as presque réussi !";
        stars = 2;
      } else if (finalScore >= 1) {
        message = "Tu as fait des progrès, mais il te reste encore à apprendre.";
        stars = 1;
      } else {
        message = "Dommage, tu n'as pas réussi cette évaluation. Essaie encore !";
        stars = 0;
      }
    } else {
      if (finalScore >= 80) {
        message = "Félicitations, tu as brillamment réussi !";
        stars = 3;
      } else if (finalScore >= 60) {
        message = "Bien joué, tu as réussi l'évaluation.";
        stars = 2;
      } else if (finalScore >= 40) {
        message = "Tu as réussi, mais il y a encore des progrès à faire.";
        stars = 1;
      } else {
        message = "Tu n'as pas réussi cette évaluation. Essaie de nouveau !";
        stars = 0;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Évaluation terminée"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 20),
            // add animation for stars
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/roadmap');
            },
            child: const Text("OK"),
          ),
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
          life: life,
        );
      default:
        return const SizedBox(); // Widget vide si type inconnu
    }
  }

  Widget buildStars(double score) {
    int stars = 0;

    if (score >= 80.0) {
      stars = 3;
    } else if (score >= 60.0) {
      stars = 2;
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
