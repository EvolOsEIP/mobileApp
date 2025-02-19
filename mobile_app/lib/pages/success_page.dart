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
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Icon(Icons.person, size: 50),
                  const Text(
                    "éclaireur",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
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
            Text("$progress/$total"),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text("voir le module"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        const SizedBox(height: 20),
      ],
    );
  }
}
