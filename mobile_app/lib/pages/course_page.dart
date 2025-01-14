import 'dart:async';
import 'package:flutter/material.dart';

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

      if (dialogs != null && dialogs.isNotEmpty) {
        _startTypingEffect(dialogs[currentDialogIndex]);
      }
    });
    _inputController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    blinkTimer.cancel();
    _inputController.removeListener(_onTextChanged);
    _inputController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _startTypingEffect(String text) {
    setState(() {
      displayedText = "";
      isTyping = true;
      isBlinking = false;
    });

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (displayedText.length < text.length) {
        setState(() {
          displayedText += text[displayedText.length];
        });
      } else {
        timer.cancel();
        setState(() {
          isTyping = false;
        });
        _startBlinkingEffect();
      }
    });
  }

  void _startBlinkingEffect() {
    blinkTimer.cancel();
    blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        isBlinking = !isBlinking;
      });
    });
  }

  void _onTap() {
    blinkTimer.cancel();
    if (isTyping) {
      setState(() {
        displayedText = dialogs[currentDialogIndex];
        isTyping = false;
      });
    } else {
      if (currentDialogIndex < dialogs.length - 1) {
        setState(() {
          currentDialogIndex++;
        });
        _startTypingEffect(dialogs[currentDialogIndex]);
      } else {
        setState(() {
          dialogs = [];
        });
      }
    }
  }

  TextEditingController _inputController = TextEditingController();

  void _nextInstruction() {
    if (_inputController.text.trim() == expectations.trim()) {
      setState(() {
        if (currentInstructionIndex < course['instructions'].length - 1) {
          currentInstruction     = course['instructions'][currentInstructionIndex + 1];
          descriptionInstruction = course['descriptions'][currentInstructionIndex + 1];
          expectations           = course['expectations'][currentInstructionIndex + 1];
          currentInstructionIndex++;
          _inputController.clear();
        } else {
          _showCompletionDialog();
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            if (dialogs != null && dialogs.isNotEmpty) ...[
              Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: isBlinking ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 84, 116)
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white70, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Assistant",
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: (isTyping) ? 10 : 0),
                        Text(
                          displayedText,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 173, 167, 167),
                            fontSize: 30,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
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
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50], // Fond légèrement coloré
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.blue, width: 1.5),
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: _nextInstruction,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _inputController.text.isNotEmpty ? Colors.lightGreen : Colors.grey
                                    ),
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
            ],
          ],
        ),
      ),
    );
  }
}
