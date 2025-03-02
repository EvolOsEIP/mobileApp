import 'package:flutter/material.dart';

// Widget pour le champ de texte
Widget inputTextWidget(BuildContext context, String expectedValue, String description) {
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
