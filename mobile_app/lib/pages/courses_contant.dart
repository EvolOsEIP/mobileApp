import "package:flutter/material.dart";

class CourseContain extends StatefulWidget {
  final dynamic courseData;
  const CourseContain({super.key, required this.courseData});

  @override
  _CourseContainState createState() => _CourseContainState();
}

class _CourseContainState extends State<CourseContain> {
  int currentStepIndex = 0;
  String userInput = "";
  bool isCompleted = false;

  // Helper to fetch the current step
  Map<String, dynamic> get currentStep =>
      widget.courseData["instructions"][currentStepIndex];

  void _nextStep() {
    if (userInput == currentStep["expected_input"]) {
      if (currentStepIndex < widget.courseData["instructions"].length - 1) {
        setState(() {
          currentStepIndex++;
          userInput = ""; // Reset input for the next step
        });
      } else {
        setState(() {
          isCompleted = true; // All steps completed
        });
      }
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erreur"),
        content: const Text("La saisie est incorrecte, réessayez."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Félicitations, vous avez terminé le cours !",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Retour"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentStep["title"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                currentStep["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentStep["description"],
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            TextField(
              onChanged: (value) => setState(() => userInput = value),
              decoration: const InputDecoration(
                labelText: "Votre réponse",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextStep,
              child: const Text("Suivant"),
            )
          ],
        ),
      ),
    );
  }
}
