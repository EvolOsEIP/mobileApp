import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/assistant.dart';

class CoursePage extends StatefulWidget {
  final dynamic courses;
  const CoursePage({super.key, required this.courses});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  dynamic dialogs;
  dynamic currentInstruction;
  dynamic descriptionInstruction;
  dynamic expectations;
  dynamic course;

  String errorMessage = '';
  int currentDialogIndex = 0;
  String displayedText = "";
  bool isTyping = false;
  bool isBlinking = false;
  Timer blinkTimer = Timer(Duration.zero, () {});

  int currentInstructionIndex = 0; // Index of the current instruction

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    course = ModalRoute.of(context)!.settings.arguments as dynamic;

    setState(() {
      dialogs = course["dialogs"];
      currentInstruction = course['instructions'][0];
      descriptionInstruction = course['descriptions'][0];
      expectations = course['expectations'][0];
    });
  }

  TextEditingController _inputController = TextEditingController();

  void _nextInstruction() {
    String userResponse = _inputController.text.trim();
    String expectedResponse = expectations.trim();

    if (userResponse == expectedResponse) {
      setState(() {
        errorMessage = '';
        if (currentInstructionIndex < course['instructions'].length - 1) {
          currentInstruction =
              course['instructions'][currentInstructionIndex + 1];
          descriptionInstruction =
              course['descriptions'][currentInstructionIndex + 1];
          expectations = course['expectations'][currentInstructionIndex + 1];
          currentInstructionIndex++;
          _inputController.clear();
        } else {
          _showCompletionDialog();
        }
      });
    } else {
      setState(() {
        errorMessage = _generateErrorMessage(userResponse, expectedResponse);
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cours complété"),
        content: Text(course["end"]),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  String _generateErrorMessage(String userResponse, String expectedResponse) {
    if (userResponse.isEmpty) {
      return 'Le champ de saisie est vide. Veuillez entrer une réponse.';
    }

    if (userResponse.toLowerCase() == expectedResponse.toLowerCase()) {
      return 'Vérifiez la majuscule: il pourrait y avoir des majuscules en trop ou manquants.';
    }

    if (userResponse.replaceAll(' ', '') ==
        expectedResponse.replaceAll(' ', '')) {
      return 'Vérifiez les espaces : il pourrait y avoir des espaces en trop ou manquants.';
    }

    if (!userResponse.endsWith('.') && expectedResponse.endsWith('.')) {
      return 'Votre réponse manque un point à la fin.';
    }

    return 'Votre réponse est incorrecte. Veuillez revoir l’instruction.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: [
            Column(
              children: [
                LinearProgressIndicator(
                  value: (currentInstructionIndex + 1) /
                      course['instructions'].length,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.95,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentInstruction,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                descriptionInstruction,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.blue, width: 1.5),
                                ),
                                child: Text(
                                  expectations,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Column(
                            children: [
                              TextField(
                                controller: _inputController,
                                decoration: InputDecoration(
                                  labelText: 'Votre réponse',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              if (errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    errorMessage,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: _nextInstruction,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _inputController.text.isNotEmpty
                                              ? Colors.lightGreen
                                              : Colors.grey),
                                  child: const Text("Suivant"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (course['dialogs'] != null && course['dialogs'].isNotEmpty)
              Assistant(
                dialogs: course['dialogs'],
                onComplete: () {
                  setState(() {
                    course['dialogs'] = [];
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
