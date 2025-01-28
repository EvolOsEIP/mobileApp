import 'package:flutter/material.dart';
import 'colors.dart'; // Import your custom colors.


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

  /// Updates the selected index and triggers a rebuild of the widget.
  void _onItemTapped(BuildContext context, int index) {
    // Navigation logic based on the selected index.
    switch (index) {
      case 0:
        // Navigate to Stats page
        Navigator.pushReplacementNamed(context, '/stats');
        break;
      case 1:
        // Navigate to Home page
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2:
        // Navigate to Profile page
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
    print("Selected Index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: CustomColors.dark_accent, // Custom background color.
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
      currentIndex: selectedIndex, // Highlights the currently selected tab.
      onTap: (index) => _onItemTapped(context, index), // Updates the selected index when a tab is tapped.
    );
  }
}
