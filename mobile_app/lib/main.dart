import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mobile_app/pages/roadmap_page.dart';
import 'package:mobile_app/pages/course_page.dart';
import 'package:mobile_app/pages/splash_screen.dart';
import 'package:mobile_app/pages/profile_page.dart';
import 'package:mobile_app/pages/success_page.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evolos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/roadmap': (context) => RoadmapPage(),
        '/course_detail': (context) => const CoursePage(courseId: 1),
        '/profile': (context) => const ProfilePage(),
        '/userprogress': (context) => const SuccessPage()
      },
    );
  }
}
