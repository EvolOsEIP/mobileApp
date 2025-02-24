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
              // Shows a loading spinner while the data is being fetched
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              // Builds a scrollable list of unit cards
              itemCount: data["units"].length, // Number of units in the data
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigates to the chapters page, passing the selected unit data
                    Navigator.pushNamed(context, '/chapters',
                        arguments: data["units"][index]);
                  },
                  child: Card(
                    color: CustomColors
                        .accent, // Custom background color for the card
                    margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16), // Adds margin around each card
                    child: SizedBox(
                      height: 250, // Sets a fixed height for each card
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Adds padding inside the card
                        child: Row(
                          children: [
                            // Displays an SVG icon for each unit
                            SvgPicture.asset(
                              "assets/images/genetic-data-svgrepo-com.svg",
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(
                                width:
                                    16), // Adds spacing between the image and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Aligns text to the start
                                children: [
                                  // Displays the unit title in bold
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      data["units"][index]['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Displays the unit description in regular text
                                  Text(
                                    data["units"][index]["description"],
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
