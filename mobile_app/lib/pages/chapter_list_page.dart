import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: data == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data["chapters"].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/courses',
                        arguments: data["chapters"][index]);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: SizedBox(
                      height: 250, // Set the desired height for the cards
                      child: Padding (
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/genetic-data-svgrepo-com.svg",
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      data["chapters"][index]['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data["chapters"][index]['description'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                );
              },
          ),
    );
  }
}
