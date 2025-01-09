import 'dart:convert';
import 'package:flutter/material.dart';

class CoursesListPage extends StatefulWidget {
  final dynamic chapter;
  const CoursesListPage({super.key, required this.chapter});

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  @override
  Widget build(BuildContext context) {
    final chapter = ModalRoute.of(context)!.settings.arguments as dynamic;


    return Scaffold(
      appBar: AppBar(
        title: Text(chapter['title']),
      ),
      body: ListView.builder(
        itemCount: chapter['courses'].length,
        itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(chapter['courses'][index]['title']),
            subtitle: Text(chapter['courses'][index]['description']),
            onTap: () {
              Navigator.pushNamed(context, '/course_detail', arguments: chapter['courses'][index]);
            },
          ),
        );
        },
      ),
    );
  }
}
