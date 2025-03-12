import 'package:flutter/material.dart';

/// Widget that displays a text input field for user interaction.
///
/// [context] - The build context.
/// [expectedValue] - The correct value expected from the user.
/// [description] - .
/// [nextStep] - Callback function triggered when the correct input is submitted.
Widget inputTextWidget(BuildContext context, String expectedValue, String? description, VoidCallback nextStep) {
  TextEditingController controller = TextEditingController();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Entrez :",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          expectedValue,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      const SizedBox(height: 15),
      Semantics(
        label: description?.isNotEmpty == true ? description : null,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Entrez votre réponse ici...",
          ),
          style: const TextStyle(fontSize: 24),
          onSubmitted: (value) {
            if (value == expectedValue) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bonne réponse ! 🎉"))
              );
              nextStep();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mauvaise réponse. Réessayez ! ❌"))
              );
            }
          },
        ),
      ),
    ],
  );
}
