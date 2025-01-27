
import 'package:flutter/material.dart'; // Flutter framework for UI components.
import 'package:mobile_app/utils/colors.dart'; // Custom color definitions for the app.

/// HomePage widget serves as the main screen of the app.
/// It displays navigation options and interacts with other screens.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

/// State class for HomePage, maintaining the current index of the bottom navigation bar.
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Tracks the currently selected tab in the bottom navigation bar.

  /// Updates the selected index and triggers a rebuild of the widget.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // navigate to the corresponding page based on the selected index.
      switch (index) {
        case 0:
          //Navigator.pushNamed(context, '/stats');
          break;
        case 2:
          Navigator.pushNamed(context, '/profile');
          break;
      }
      print("Index: $_selectedIndex"); // Logs the selected index for debugging.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.dark_accent, // Sets a custom background color for the AppBar.
        title: const Text(
          'Accueil', // AppBar title.
          style: TextStyle(color: Colors.white), // White text color for better contrast.
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the body content.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill the width.
          children: [
            const SizedBox(height: 16.0), // Adds spacing at the top of the body.

            // Row containing two cards side by side.
            Row(
              children: [
                // First card: "Profile"
                Expanded(
                  child: SizedBox(
                    height: 200, // Fixed height for the card.
                    child: Card(
                      elevation: 4, // Adds a shadow effect.
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile'); // Navigates to the '/profile' page when tapped.
                          print("Profile"); // Logs "Profile" when tapped.
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0), // Uniform padding inside the card.
                            child: Text(
                              'Profile', // Card text.
                              textAlign: TextAlign.center, // Center-align the text.
                              style: Theme.of(context).textTheme.bodyLarge, // Uses the app's theme for styling.
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // Space between the two cards.

                // Second card: "Voir ma progression" (View Progress).
                Expanded(
                  child: SizedBox(
                    height: 200, // Fixed height for the card.
                    child: Card(
                      elevation: 4, // Adds a shadow effect.
                      child: InkWell(
                        onTap: () {
                          print("Voir ma progression"); // Logs "Voir ma progression" when tapped.
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0), // Uniform padding inside the card.
                            child: Text(
                              'Voir ma progression', // Card text.
                              textAlign: TextAlign.center, // Center-align the text.
                              style: Theme.of(context).textTheme.bodyLarge, // Uses the app's theme for styling.
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Adds spacing below the row.

            // Third card: "Voir la liste des modules" (View the list of modules).
            SizedBox(
              height: 200, // Fixed height for the card.
              child: Card(
                elevation: 4, // Adds a shadow effect.
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/units'); // Navigates to the '/units' page when tapped.
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Uniform padding inside the card.
                      child: Text(
                        'Voir la liste des modules', // Card text.
                        textAlign: TextAlign.center, // Center-align the text.
                        style: Theme.of(context).textTheme.bodyLarge, // Uses the app's theme for styling.
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation bar for navigating between sections of the app.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.dark_accent, // Custom background color for the navigation bar.
        selectedItemColor: CustomColors.accent, // Highlight color for the selected item.
        unselectedItemColor: Colors.white, // White color for unselected items.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats), // Stats icon.
            label: 'Stats', // Label for the stats tab.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Home icon.
            label: 'Acceuil', // Label for the home tab.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile icon.
            label: 'Profile', // Label for the profile tab.
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the currently selected tab.
        onTap: _onItemTapped, // Updates the selected index when a tab is tapped.
      ),
    );
  }
}
