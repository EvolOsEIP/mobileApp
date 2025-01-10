import 'dart:convert';
import "package:flutter/material.dart";
import 'dart:async';

class CoursePage extends StatefulWidget {
  final dynamic courses;
  const CoursePage({super.key, required this.courses});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final List<String> dialogs = [
    "Welcome to the world of Flutter!",
    "Here, you'll learn to create amazing apps.",
    "Let's begin our journey together.",
    "Good luck, and have fun coding!"
  ];

  int currentDialogIndex = 0;
  String displayedText = "";
  bool isTyping = false;
  bool isBlinking = false;
  Timer blinkTimer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    _startTypingEffect(dialogs[currentDialogIndex]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            Center(
              child: Text(
                "cours",
                style: TextStyle(
                  color: const Color.fromARGB(77, 247, 17, 17),
                  fontSize: 24,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
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
          ],
        ),
      ),
    );
  }
}
