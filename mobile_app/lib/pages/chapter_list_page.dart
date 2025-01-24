import 'dart:convert'; // Provides JSON encoding and decoding utilities.
import 'package:flutter/material.dart'; // Flutter framework for UI components.
import 'package:flutter_svg/flutter_svg.dart'; // Library to handle SVG images.
import 'package:http/http.dart' as http; // Library for making HTTP requests.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Library to read configuration from a .env file.

import 'package:mobile_app/utils/colors.dart'; // Custom color definitions for the app.


/// A StatefulWidget to display a list of chapters in a unit.
class ChapterListPage extends StatefulWidget {
  const ChapterListPage({super.key});

  @override
  _ChapterListPageState createState() => _ChapterListPageState();
}

/// The state class for ChapterListPage, responsible for rendering the UI.
class _ChapterListPageState extends State<ChapterListPage> {
  dynamic units = null; // Variable to store the list of chapters.


  /// Fetches the list of chapters from the API.
  Future<void> _fetchUnits() async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL'].toString() + '/chapters'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
      if (response.statusCode == 200) {
        setState(() {
          units = jsonDecode(response.body);
        });
      } else {
        setState(() {
          units = null;
        });
        print('Failed to load chapters');
      }
    } catch (e) {
      print('Failed to load chapters');
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUnits();
  }
  @override
  Widget build(BuildContext context) {
    print(dotenv.env['API_URL']);
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
              itemCount: units.length, // Total number of chapters.
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigate to the courses page, passing the selected chapter as an argument.
                   // Navigator.pushNamed(context, '/courses',
                   //     arguments: units[index]);
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
                                // Add three stars
                                Row(
                                  children: const [
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          units[index]['title'], // Chapter title.
                                          style: const TextStyle(
                                            fontSize: 18, // Font size for the title.
                                            fontWeight: FontWeight.bold, // Bold font for emphasis.
                                          ),
                                          softWrap: true, // Allow text to wrap to the next line if it exceeds the width.
                                          overflow: TextOverflow.ellipsis, // Ellipsis for overflow text.
                                          maxLines: 2, // Maximum of 2 lines for the title.
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  // Chapter description text.
                                  Text(
                                    units[index]['description'],
                                    style: const TextStyle(
                                      fontSize: 14
                                    ), // Smaller font size for description.
                                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow text.
                                    maxLines: 5, // Maximum of 3 lines for the description.
                                  ),
                                  const Spacer(),
                                  // Add text for the status of the chapter ("En cours", "Terminé" or "À venir"), and the number of courses completed
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Status: ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            //units[index]['status'],
                                            "En cours",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${units[index]['completedCourses']} / ${units[index]['totalCourses']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
