import 'dart:convert';
import 'package:flutter/material.dart';

class ChapterListPage extends StatefulWidget {
  const ChapterListPage({super.key});
  @override
  _ChapterListPageState createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    getChapters();
  }

  Future<void> getChapters() async {
    try {
      String dataString = await DefaultAssetBundle.of(context)
          .loadString('assets/chapters.json');

      setState(() {
        data = jsonDecode(dataString);
      });


    } catch (e) {
      print("Error loading the JSON file: $e");
    }
  }

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
      // create a card for each chapter in the list
      body: data == null
          ? const Center(
              child: CircularProgressIndicator(),
            ) : ListView.builder(
              itemCount: data["chapters"].length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(data["chapters"][index]['title']),
                    subtitle: Text(data["chapters"][index]['description']),
                    onTap: () {
                      Navigator.pushNamed(context, '/chapter',
                          arguments: data["chapters"][index]['title']);
                    },
                  ),
                );
              }
            ),
    );
  }
}
