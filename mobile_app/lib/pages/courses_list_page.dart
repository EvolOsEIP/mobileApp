import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/utils/colors.dart';
import 'dart:convert'; // Provides JSON encoding and decoding utilities.
import 'package:http/http.dart' as http; // Library for making HTTP requests.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Library to read configuration from a .env file.

// A page to display a list of courses for a selected chapter
class CoursesListPage extends StatefulWidget {
  final dynamic chapter; // Holds the data for the current chapter
  const CoursesListPage({super.key, required this.chapter});

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  dynamic units = null; // Variable to store the list of chapters.

  /// Fetches the list of chapters from the API.
  Future<void> _fetchUnits(String index) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL'].toString() +
            '/chapters/' +
            index +
            '/courses'),
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
  Widget build(BuildContext context) {
    // Retrieves the chapter details passed through the navigation route
    final chapter = ModalRoute.of(context)!.settings.arguments as dynamic;
    // print(chapter);
    _fetchUnits(chapter['ChapterId'].toString());
    print(units);
    return Scaffold(
      appBar: AppBar(
        // Sets the AppBar title to the chapter's title
        title: Text(chapter['title']),
      ),
      body: chapter == null
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show a loader if data is null.
            )
          : ListView.builder(
              // Dynamically builds a list of courses based on the number of items.
              itemCount: units.length, // Total number of courses.
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/course_detail', arguments: {
                      'courseIndex': chapter,
                      'chapterIndex': index
                    });
                  },
                  child: Card(
                    color: CustomColors
                        .accent, // Use custom accent color for the card.
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16), // Card spacing.
                    child: SizedBox(
                      height: 250, // Set a fixed height for the cards.
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Uniform padding for the card content.
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
                            const SizedBox(
                                width: 16), // Space between the image and text.
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start.
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          units[index]
                                              ['title'], // Chapter title.
                                          style: const TextStyle(
                                            fontSize:
                                                18, // Font size for the title.
                                            fontWeight: FontWeight
                                                .bold, // Bold font for emphasis.
                                          ),
                                          softWrap:
                                              true, // Allow text to wrap to the next line if it exceeds the width.
                                          overflow: TextOverflow
                                              .ellipsis, // Ellipsis for overflow text.
                                          maxLines:
                                              2, // Maximum of 2 lines for the title.
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
                                        fontSize:
                                            14), // Smaller font size for description.
                                    overflow: TextOverflow
                                        .ellipsis, // Ellipsis for overflow text.
                                    maxLines:
                                        5, // Maximum of 3 lines for the description.
                                  ),
                                  const Spacer(),
                                  // Add text for the status of the chapter ("En cours", "Terminé" or "À venir"), and the number of courses completed
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            'non commencé', // units[index]['status'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
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
