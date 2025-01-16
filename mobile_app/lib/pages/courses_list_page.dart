import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// A page to display a list of courses for a selected chapter
class CoursesListPage extends StatefulWidget {
  final dynamic chapter; // Holds the data for the current chapter
  const CoursesListPage({super.key, required this.chapter});

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  @override
  Widget build(BuildContext context) {
    // Retrieves the chapter details passed through the navigation route
    final chapter = ModalRoute.of(context)!.settings.arguments as dynamic;

    return Scaffold(
      appBar: AppBar(
        // Sets the AppBar title to the chapter's title
        title: Text(chapter['title']),
      ),
      body: ListView.builder(
        // Creates a scrollable list with one item per course in the chapter
        itemCount: chapter['courses'].length,
        itemBuilder: (context, index) {
          // Build a clickable card for each course
          return InkWell(
            onTap: () {
              // Navigates to the course detail page, passing the selected course data
              Navigator.pushNamed(
                context,
                '/course_detail',
                arguments: chapter['courses'][index],
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16), // Adds margin around the card
              child: SizedBox(
                height: 250, // Sets a fixed height for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Adds padding inside the card
                  child: Row(
                    children: [
                      // Displays an SVG icon (useful for representing the course visually)
                      SvgPicture.asset(
                        "assets/images/genetic-data-svgrepo-com.svg",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 16), // Adds space between the image and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start
                          children: [
                            // Course title displayed in bold text
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
                            // Course description displayed in regular text
                            Text(
                              chapter['courses'][index]['description'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
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
