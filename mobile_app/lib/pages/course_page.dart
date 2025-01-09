import 'dart:convert';
import "package:flutter/material.dart";

class CoursePage extends StatefulWidget {
  final dynamic courses;
  const CoursePage({super.key, required this.courses});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    final courses = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text(courses["title"]),
      ),
      body: Center(
        child: Text(courses["description"]),
      ),
    );
  }
}
