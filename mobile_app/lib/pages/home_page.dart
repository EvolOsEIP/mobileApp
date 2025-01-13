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
        title: Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              child: Text("Item 1"),
            ),
            Row(
              children: [
                Card(
                  child: Text("Item 2"),
                ),
                Card(
                  child: Text("Item 3"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
