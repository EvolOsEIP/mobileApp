import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/assistant.dart';

/// This part is used to load courses content.
///
/// This page display the different steps that composed a course load from a json file.
/// The user can enter his answer and we compare to the exception given in the json file.
///

class CoursePage extends StatefulWidget {

  /// Courses load from the json file is load here.
  final dynamic courses;

  /// Creation of an instance 'CoursesPage'.
  const CoursePage({super.key, required this.courses});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  /// Dialogs used by the Assistant.
  dynamic dialogs;

  /// Instruction used to give the task to do to the user.
  dynamic currentInstruction;

  /// Description more details of the instruction for the user.
  dynamic descriptionInstruction;

  /// Expectation for the current step.
  dynamic expectations;

  /// Data of the current chapter.
  dynamic chapter;

  /// Data of the current course.
  dynamic course;

  /// ???
  dynamic args;

  /// Error message display if the user's answer is not correct.
  String errorMessage = '';

  /// Index for the dialogs of the assistant.
  int currentDialogIndex = 0;

  /// Index for the current Instruction
  int currentInstructionIndex = 0;

  /// ???
  String displayedText = "";

  /// Boolean to know if the assistant is writing or not.
  bool isTyping = false;

  /// ???
  bool isBlinking = false;

  /// ???
  Timer blinkTimer = Timer(Duration.zero, () {});

  /// Controller to check the field input.
  final _inputController = TextEditingController();

  /// Initialize the widget.
  ///
  /// Add a listener to check the value of the input field.
  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      /// update the variable
      setState(() {
      });
    });
  }

  /// Clean the resources used by the widget.
  ///
  /// Delete the listener to avoid memory link
  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  ///Updates the course and chapter data when dependencies change.
  ///
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)!.settings.arguments as dynamic;
    chapter = args['chapter'];
    course = chapter['courses'][args['index']];

    setState(() {
      dialogs = course["dialogs"];
      currentInstruction = course['instructions'][0];
      descriptionInstruction = course['descriptions'][0];
      expectations = course['expectations'][0];
    });
  }

  /// To go to another step
  ///
  /// When the 'Next' button is pressed this method is call.
  /// Check if the user answer is correct before to go to another step.
  /// If yes : load the next instruction or display the ended message.
  /// If no : call the function to set the error message.
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

  /// Displays a pop-up when the course is completed.
  ///
  /// The pop-up shows a completion message from the course content and redirects to the courses list.
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cours complété"),
        content: Text(course["end"]),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/courses', arguments: chapter);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  /// Generates and display a specific error message based on the user's response.
  ///
  /// If the answer doesn't match with the expected one, we try to help the user.
  /// We check what is wrong and if we know we inform the user.
  /// Error handling :
  /// - Missing or Too many capital(s).
  /// - Missing a point at the end of the sentence.
  /// - Missing or Too many space(s).
  ///
  /// Returns :
  /// - A error message string.
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

  /// Builds the UI for the course page.
  ///
  /// Starts with the assistant's dialog.
  /// Displays the current step of the course, the progress bar and the completion dialog at the end of the course.
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
                                decoration: const InputDecoration(
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
                                      backgroundColor: _inputController.text.isNotEmpty
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
