import 'package:flutter/material.dart';

class ChapterListPage extends StatefulWidget {
  const ChapterListPage({super.key});
  @override
  _ChapterListPageState createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  List<String> chapters = [
    "Chapter 1",
    "Chapter 2",
    "Chapter 3"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        title: const Text(
          'Chapters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),

        ),
      ),
      body: Center(
        child: Column(
          // create a card for each chapter
          children: chapters.map((chapter) {
            return Card(
              child: ListTile(
                title: Text(chapter),
                onTap: () {
                  // navigate to the chapter page
                  Navigator.pushNamed(context, '/chapter');
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
