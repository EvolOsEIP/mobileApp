import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/navbar.dart';

Future<List<dynamic>> fetchModules(header) async {
  print(header);
  var url = Uri.http('10.0.2.2:3000', '/api/modules');
  try {
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load modules');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

class RoadmapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future:
            fetchModules({'Authorization': dotenv.env['API_KEY'].toString()}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading roadmap'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No modules available'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                RoadmapListWidget(modules: snapshot.data!),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomNavbar(
            profileImageUrl:
                "https://randomuser.me/api/portraits/women/44.jpg"),
      ),
    );
  }
}

class RoadmapListWidget extends StatelessWidget {
  final List<dynamic> modules;

  RoadmapListWidget({required this.modules});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: modules
          .map((module) => Column(
                children: [
                  RoadmapSection(
                    title: module['modulename'],
                    roadmap: RoadmapWidget(courses: module['courses']),
                  ),
                  SizedBox(height: 20),
                ],
              ))
          .toList(),
    );
  }
}

class RoadmapSection extends StatelessWidget {
  final String title;
  final Widget roadmap;

  RoadmapSection({required this.title, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        roadmap,
      ],
    );
  }
}

class RoadmapWidget extends StatelessWidget {
  final List<dynamic> courses;

  RoadmapWidget({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: courses
          .map((course) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Align(
                  alignment: (course['courseIndex'] % 2 == 0)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: CourseHexagon(title: course['title']),
                ),
              ))
          .toList(),
    );
  }
}

class CourseHexagon extends StatelessWidget {
  final String title;

  CourseHexagon({required this.title});

  @override
  Widget build(BuildContext context) {
    double size = 100.0;
    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        width: size,
        height: size,
        color: Color(0xFF7FD1B9),
        child: Center(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final a = w / 2;
    final b = sqrt(3) / 2 * a;

    path.moveTo(a, 0);
    path.lineTo(w, b);
    path.lineTo(w, h - b);
    path.lineTo(a, h);
    path.lineTo(0, h - b);
    path.lineTo(0, b);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
