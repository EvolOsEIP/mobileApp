import 'dart:async';
import 'package:flutter/material.dart';

class Assistant extends StatefulWidget {
  final List<dynamic> dialogs;
  final VoidCallback? onComplete;

  const Assistant({
    Key? key,
    required this.dialogs,
    this.onComplete,
  }) : super(key: key);

  @override
  _AssistantState createState() => _AssistantState();
}

class _AssistantState extends State<Assistant> {
  int currentDialogIndex = 0;
  String displayedText = "";
  bool isTyping = false;
  bool isBlinking = false;
  Timer blinkTimer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    if (widget.dialogs.isNotEmpty) {
      _startTypingEffect(widget.dialogs[currentDialogIndex]);
    }
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
        displayedText = widget.dialogs[currentDialogIndex];
        isTyping = false;
      });
    } else {
      if (currentDialogIndex < widget.dialogs.length - 1) {
        setState(() {
          currentDialogIndex++;
        });
        _startTypingEffect(widget.dialogs[currentDialogIndex]);
      } else {
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
        setState(() {
          displayedText = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        children: [
          if (widget.dialogs.isNotEmpty) ...[
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: isBlinking ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 51, 84, 116).withOpacity(0.8),
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
                      const SizedBox(height: 10),
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
          ],
        ],
      ),
    );
  }
}
