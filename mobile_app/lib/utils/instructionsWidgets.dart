import 'package:flutter/material.dart';

// Widget pour afficher une image
Widget imageWidget(BuildContext context, String imagePath, String description) {
  return Column(
    children: [
      Image.asset(
        imagePath,
        fit: BoxFit.contain,
        height: MediaQuery.of(context).size.height * 0.25,
        width: double.infinity,
      ),
      const SizedBox(height: 10),
      Text(
        description,
        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      ),
    ],
  );
}