import 'dart:ffi';

import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';

class CoursePage extends StatefulWidget {
  final dynamic courses;
  const CoursePage({super.key, required this.courses});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  dynamic data;
  dynamic dialogs = ["Hello! I'm your assistant."];
  dynamic currentCoursePage;
  dynamic courseData;
  dynamic currentInstruction = "get ready to start the course";

  int currentDialogIndex = 0;
  String displayedText = "";
  bool isTyping = false;
  bool isBlinking = false;
  Timer blinkTimer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    _startTypingEffect(dialogs[currentDialogIndex]);
    getChapters();
  }

  @override
  void dispose() {
    blinkTimer.cancel();
    super.dispose();
  }

  void _startTypingEffect(String text) {
    setState(() {
      displayedText = "";
      isTyping = true;
      isBlinking = false; // Stop blinking when new text starts typing
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
    blinkTimer?.cancel(); // Cancel any existing timer
    blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        isBlinking = !isBlinking;
      });
    });
  }

  void _onTap() {
    blinkTimer?.cancel(); // Stop blinking on user interaction
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
        Navigator.pop(context);
      }
    }
  }

  int currentPageIndex = 0; // Index of the current course page
  int currentInstructionIndex = 0; // Index of the current instruction

  void _nextInstruction() {
    setState(() {
      if (currentInstructionIndex <
          courseData['course_pages'][currentPageIndex]['instructions'].length -
              1) {
        currentInstructionIndex++;
      } else if (currentPageIndex < courseData['course_pages'].length - 1) {
        currentInstructionIndex = 0;
        currentPageIndex++;
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Course Completed"),
        content: Text("You've completed all the instructions!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> getChapters() async {
    try {
      String dataString = await DefaultAssetBundle.of(context)
          .loadString('assets/chapters.json');

      setState(() {
        data = jsonDecode(dataString);
        dialogs = data["chapters"][0]["courses"][0]["dialogs"];
        currentCoursePage =
            data["chapters"][0]["courses"][0]["course_pages"][0];
        courseData = data["chapters"][0]["courses"][0];
        // currentCoursePage['instructions'][currentInstructionIndex];
      });
    } catch (e) {
      print("Error loading the JSON file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: isBlinking ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 51, 84, 116).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "assistant",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: (isTyping) ? 10 : 0),
                      Text(
                        displayedText,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 173, 167, 167),
                          fontSize: 30,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            LinearProgressIndicator(
              value: (currentInstructionIndex + 1) /
                  currentCoursePage['instructions'].length,
            ),
            SizedBox(height: 20),
            // Display current instruction
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentInstruction,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            // Interaction Area
            ElevatedButton(
              onPressed: _nextInstruction,
              child: Text("Next"),
            ),
            SizedBox(height: 20),
          ],
          // ],
        ),
      ),
    );
  }
}
