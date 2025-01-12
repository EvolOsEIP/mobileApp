import 'package:flutter/material.dart';
import 'package:mobile_app/pages/chapter_list_page.dart';
import 'package:mobile_app/pages/courses_list_page.dart';
import 'package:mobile_app/pages/course_page.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const ChapterListPage(),
        '/courses': (context) => const CoursesListPage(chapter: null),
        '/course_detail': (context) => const CoursePage(
              courses: 0,
            ),
      },
    );
  }
}
