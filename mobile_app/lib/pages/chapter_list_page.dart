
import 'dart:convert'; // Provides JSON encoding and decoding utilities.
import 'package:flutter/material.dart'; // Flutter framework for UI components.
import 'package:flutter_svg/flutter_svg.dart'; // Library to handle SVG images.

import 'package:mobile_app/utils/colors.dart'; // Custom color definitions for the app.

/// A StatefulWidget to display a list of chapters in a unit.
class ChapterListPage extends StatefulWidget {
  final dynamic units; // Data containing information about units and chapters.
  const ChapterListPage({super.key, required this.units});

  @override
  _ChapterListPageState createState() => _ChapterListPageState();
}

/// The state class for ChapterListPage, responsible for rendering the UI.
class _ChapterListPageState extends State<ChapterListPage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the passed 'units' argument from the navigation route.
    final units = ModalRoute.of(context)!.settings.arguments as dynamic;

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes the shadow under the AppBar.
        title: const Text(
          'Chapters', // Title displayed on the AppBar.
          style: TextStyle(
            color: Colors.black, // Black text color.
            fontSize: 20, // Font size for the title.
          ),
        ),
      ),
      body: units == null
          ? const Center(
              child: CircularProgressIndicator(), // Show a loader if data is null.
            )
          : ListView.builder(
              // Dynamically builds a list of chapters based on the number of items.
              itemCount: units["chapters"].length, // Total number of chapters.
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigate to the courses page, passing the selected chapter as an argument.
                    Navigator.pushNamed(context, '/courses',
                        arguments: units["chapters"][index]);
                  },
                  child: Card(
                    color: CustomColors.accent, // Use custom accent color for the card.
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16), // Card spacing.
                    child: SizedBox(
                      height: 250, // Set a fixed height for the cards.
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Uniform padding for the card content.
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/genetic-data-svgrepo-com.svg",
                                  width: 100, // Image width.
                                  height: 100, // Image height.
                                ),
                                const SizedBox(height: 16),
                                // add three stars
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 16), // Space between the image and text.
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start.
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0), // Space below the title.
                                    child: Text(
                                      units["chapters"][index]['title'], // Chapter title.
                                      style: const TextStyle(
                                        fontSize: 18, // Font size for the title.
                                        fontWeight: FontWeight.bold, // Bold font for emphasis.
                                      ),
                                    ),
                                  ),
                                  // Chapter description text.
                                  Text(
                                    units["chapters"][index]['description'],
                                    style: const TextStyle(fontSize: 14), // Smaller font size for description.
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
