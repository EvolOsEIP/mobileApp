import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/navbar.dart';
import 'package:mobile_app/pages/NEWcourse_page.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:hexagon/hexagon.dart';

Future<List<dynamic>> fetchModules(header, context) async {
  // print(header);
  try {
    var url = Uri.http(dotenv.env["HOST_URL"].toString(), '/api/modules');
    final response = await http
        .get(url, headers: header)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load modules');
    }
  } catch (e) {
    print('Error: $e');
    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString('assets/json/offline_modules.json');
      return jsonDecode(data);
    } catch (e) {
      print('Error loading offline modules: $e');
      return [];
    }
  }
}

class RoadmapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: fetchModules(
            {'Authorization': dotenv.env['API_KEY']?.toString() ?? ''},
            context),
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
                SizedBox(height: 20),
                Image.asset('assets/images/logo.png', height: 100),
                SizedBox(height: 20),
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
                  SizedBox(height: 10),
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
        DividerWidget(title: title, context: context),
        SizedBox(height: 10),
        roadmap,
      ],
    );
  }
}

class DividerWidget extends StatelessWidget {
  final String title;
  final BuildContext context;

  DividerWidget({required this.title, required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: CustomColors.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primary)),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: CustomColors.primary,
          ),
        ),
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
                  child: CourseHexagon(
                    title: course['title'],
                    courseId: course['courseId'],
                    description: course['description'],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class CourseHexagon extends StatelessWidget {
  final String title;
  final int courseId;
  final String description;

  CourseHexagon(
      {required this.title, required this.courseId, required this.description});

  @override
  Widget build(BuildContext context) {
    double textWidth = (title.length * 4.0).clamp(80.0, 200.0);
    double size = textWidth + 20;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color.fromRGBO(55, 190, 240, 1)),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(description, textAlign: TextAlign.center),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursePage(courseId: courseId),
                      ),
                    );
                  },
                  child: Text("Play"),
                ),
              ],
            ),
          ),
        );
      },
      child: HexagonWidget.pointy(
        width: size,
        color: CustomColors.accent,
        elevation: 10,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: textWidth / 8,
            ),
          ),
        ),
      ),
    );
  }
}
