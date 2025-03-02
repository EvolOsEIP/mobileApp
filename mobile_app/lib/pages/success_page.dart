import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "MES BADGES",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Row(
                children: [
                  Icon(Icons.person, size: 50),
                  const Text(
                    "éclaireur",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 50),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "4 / 22\nCOLLECTION TOTALE",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Divider
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            // filter button
            Align(
              alignment: Alignment.centerRight,
              child:
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  // #227C9D
                  side: BorderSide(color: Color.fromRGBO(34, 124, 157, 1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Filtres"),
              ),
            ),
            const SizedBox(height: 20),
            BadgeSection(title: "Île 1", progress: 3, total: 7),
            BadgeSection(title: "Île 2", progress: 1, total: 10),
            BadgeSection(title: "Île 3", progress: 0, total: 5),
          ],
        ),
      ),
    );
  }
}

class BadgeSection extends StatelessWidget {
  final String title;
  final int progress;
  final int total;

  const BadgeSection({
    required this.title,
    required this.progress,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress / total,
                color: Colors.orange,
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(width: 5),
            Text("$progress/$total"),
            const SizedBox(width: 10),
            Container(
              width: 100,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  // borderRadius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Voir le module",
                  style: TextStyle(
                    color: Colors.black,

                    ),

                  ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              total,
              (index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: index < progress ? Colors.orange : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: index >= progress
                      ? const Icon(Icons.lock, color: Colors.black)
                      : null,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
