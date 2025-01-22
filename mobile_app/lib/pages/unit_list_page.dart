
import 'dart:convert'; // For decoding JSON data
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For displaying SVG images
import 'package:mobile_app/utils/colors.dart'; // Custom colors used in the app

// A page that displays a list of units loaded from a local JSON file
class UnitListPage extends StatefulWidget {
  const UnitListPage({super.key});

  @override
  _UnitListPageState createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  dynamic data; // Holds the JSON data for units

  @override
  void initState() {
    super.initState();
    getDatas(); // Fetches data when the widget is initialized
  }

  // Asynchronous method to load and parse JSON data from the assets folder
  Future<void> getDatas() async {
    try {
      // Loads the JSON file as a string
      String dataString = await DefaultAssetBundle.of(context)
          .loadString('assets/chapters.json');

      // Parses the JSON string into a Dart object and updates the state
      setState(() {
        data = jsonDecode(dataString);
      });
    } catch (e) {
      // Logs an error if the JSON file could not be loaded
      print("Error loading the JSON file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with a title for the page
        title: const Text('Liste des modules'),
      ),

      body: data == null
          ? const Center(
              child: CircularProgressIndicator(), // Show a loader if data is null.
            )
          : ListView.builder(
              // Dynamically builds a list of units  based on the number of items.
              itemCount: data["units"].length, // Total number of units.
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigate to the courses page, passing the selected chapter as an argument.
                    Navigator.pushNamed(context, '/chapters',
                        arguments: data["units"][index]);
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
                                          data["units"][index]['title'], // Unit title.
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
                                    data["units"][index]['description'],
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
                                            data["units"][index]['status'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${data['units'][index]['completedChapters']} / ${data['units'][index]['totalChapters']}",
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
