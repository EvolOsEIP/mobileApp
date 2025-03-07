import 'package:flutter/material.dart';

/// Widget that displays a text input field for user interaction.
///
/// [context] - The build context.
/// [expectedValue] - The correct value expected from the user.
/// [description] - .
/// [nextStep] - Callback function triggered when the correct input is submitted.
Widget inputTextWidget(BuildContext context, String expectedValue, String description, VoidCallback nextStep) {
  TextEditingController controller = TextEditingController();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(description, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Entrez votre réponse ici...",
        ),
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
    ],
  );
}
