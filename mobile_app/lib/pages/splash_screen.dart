import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to the CoursePage after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(), // Pass your courses here
        ),
      );
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 84, 116),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Image.asset(
              'assets/images/logo.png', // Replace with your logo file path
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            // App name or slogan
            const Text(
              "Welcome to Your Learning App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Learn. Grow. Succeed.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}
