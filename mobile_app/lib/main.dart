import 'package:flutter/material.dart';
import 'modules/chapters/courses/keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Input Example',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const TextInputPage(title: 'Test virtual keyboard'),
    );
  }
}
