import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.dark_accent,
        title: const Text(
          'Acceuil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            // Row with two cards
            Row(
              children: [
                // Second card
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          print("Profile");
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Profile',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Third card
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          print("Voir ma progression");
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Voir ma progression',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // First card
            SizedBox(
              height: 200,
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    print("Voir la liste des modules");
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Voir la liste des modules',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
