import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/course_detail', arguments: {
                'chapter': chapter,
                'index': index
              } //chapter['courses'][index],

                  );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: SizedBox(
                height: 250, // Set the desired height for the cards
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(children: [
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
                              chapter['courses'][index]['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            chapter['courses'][index]['description'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
