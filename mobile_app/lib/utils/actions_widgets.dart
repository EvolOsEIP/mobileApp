import 'package:flutter/material.dart';

/// Widget that displays a text input field for user interaction.
///
/// [context] - The build context.
/// [expectedValue] - The correct value expected from the user.
/// [description] - .
/// [nextStep] - Callback function triggered when the correct input is submitted.
///
class InputTextWidget extends StatefulWidget {
  final String expectedValue;
  final String? description;
  final VoidCallback nextStep;
  final double? score;

  const InputTextWidget({super.key,
    required this.expectedValue,
    required this.nextStep,
    this.description,
    this.score
  });
  @override
  _InputTextWidgetState createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  TextEditingController controller = TextEditingController();
  String errorMessage = '';

  // Function to handle error input
  String handleErrorInputText(String textEnter) {
    if (textEnter.toLowerCase() == widget.expectedValue.toLowerCase()) {
      return "Verifier la majuscule: il pourrait y avoir des majuscules en trop ou manquants.";
    }

    if (textEnter.replaceAll(' ', '') == widget.expectedValue.replaceAll(' ', '')) {
      return 'Vérifiez les espaces : il pourrait y avoir des espaces en trop ou manquants.';
    }

    if (!textEnter.endsWith('.') && widget.expectedValue.endsWith('.')) {
      return 'Votre réponse manque un point à la fin.';
    }
    return "Votre réponse est incorrecte. Veuillez revoir l’instruction.";
  }

  // Function to handle validation when the button is pressed
  void validateInput() {
    final userInput = controller.text;
    setState(() {
      if (userInput == widget.expectedValue) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bonne réponse ! 🎉"))
        );
        errorMessage = '';
        controller.clear();
        widget.nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Mauvaise réponse. Réessayez ! ❌"))
        );
        errorMessage = handleErrorInputText(userInput);
      }
    });
  }

  void skipStep() {
    setState(() {
      errorMessage = '';
      controller.clear();
      widget.nextStep();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Entrez :", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.grey[700]),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            widget.expectedValue,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.blue),
          ),
        ),
        const SizedBox(height: 15),
        Semantics(
          label: widget.description?.isNotEmpty == true ? widget.description : null,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder(),hintText: "Entrez votre réponse ici..."),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        Row( mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.score != null)
            ElevatedButton(
              onPressed: skipStep,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text("Je ne sais", style: TextStyle(color: Colors.white)),
            ),
            if (widget.score != null)
              const SizedBox(width: 10),
            ElevatedButton(
              onPressed: validateInput,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Valider", style: TextStyle(color: Colors.white))
            )
          ]
        ),
        // Display the error message below the TextField
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}