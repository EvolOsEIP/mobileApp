import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/navbar.dart';

Future requestApi(endpoint, path, body, header, type) async {
  var url = Uri.http(endpoint, path);

  dynamic response;
  try {
    if (type == 'get') {
      response = await http.get(url, headers: header);
    } else if (type == 'update') {
      response = await http.put(url, body: body, headers: header);
    } else if (type == 'post') {
      response = await http.post(url, body: body, headers: header);
    }
    print(response.body);
    return response;
  } catch (e) {
    print('Error: $e');
  }
}

class CourseHexagon extends StatelessWidget {
  final String title;
  final int stars;
  final String status;

  CourseHexagon(
      {required this.title, required this.stars, required this.status});

  Color getHexagonColor() {
    switch (status) {
      case "done":
        return Color(0xFF7FD1B9);
      case "current":
        return Color(0xFFF6AE2D);
      default:
        return Color(0xFFB09E99);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 100.0 + Random().nextInt(20);
    return Column(
      children: [
        ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            width: size,
            height: size,
            color: getHexagonColor(),
            child: Stack(
              children: [
                Center(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white))),
                if (status == "locked")
                  Positioned(
                      right: 5,
                      top: 5,
                      child: Icon(Icons.lock, color: Colors.white)),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3,
              (index) => Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.black,
                    size: 16,
                  )),
        )
      ],
    );
  }
}

class EvaluationHexagon extends StatelessWidget {
  final String title;

  EvaluationHexagon({required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        width: 150,
        height: 150,
        color: Color(0xFF227c9d),
        child: Center(
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white))),
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

class RoadmapPage extends StatefulWidget {
  @override
  _RoadmapPageState createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  List<dynamic> modules = [];

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

  Future<void> fetchModules() async {
    var response = await requestApi(
      '10.0.2.2:3000',
      '/api/courses',
      {},
      {
        'Authorization':
            'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJlbWFpbCI6ImFkbWluQGV4YW1wbGUuY29tIiwicGFzc3dvcmRoYXNoIjoic2VjdXJlcGFzc3dvcmQxMjMiLCJjcmVhdGVkYXQiOiIyMDI1LTAzLTA0VDA0OjM1OjM5LjY2M1oiLCJyb2xlIjoiYWRtaW4ifQ.fT-SZtGJD63bFe7NSL86Z11h1WHw7ny746OfZQTfnic'
      },
      'get',
    );

    if (response != null && response.statusCode == 200) {
      List<dynamic> courses = jsonDecode(response.body);
      Map<int, List<dynamic>> groupedModules = {};

      for (var course in courses) {
        int moduleId = course['moduleid'] ?? 1;
        if (!groupedModules.containsKey(moduleId)) {
          groupedModules[moduleId] = [];
        }
        groupedModules[moduleId]!.add(course);
      }

      setState(() {
        modules = groupedModules.entries
            .map((e) => {
                  'title': 'Module ${e.key}',
                  'courses': e.value,
                  'evaluation': 'Evaluation ${e.key}'
                })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            RoadmapListWidget(modules: modules),
          ],
        ),
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
                    title: module['title'],
                    roadmap: RoadmapWidget(
                      courses: module['courses'],
                      evaluation: module['evaluation'],
                    ),
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
  final String evaluation;

  RoadmapWidget({required this.courses, required this.evaluation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...courses.map((course) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CourseHexagon(
                title: course['title'],
                stars: 3,
                status: course['levelrequired'],
              ),
            )),
        SizedBox(height: 30),
        EvaluationHexagon(title: evaluation),
        SizedBox(height: 50),
      ],
    );
  }
}
