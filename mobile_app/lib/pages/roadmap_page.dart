import 'package:flutter/material.dart';
import 'package:mobile_app/pages/evaluation_page.dart';
import 'package:mobile_app/utils/navbar.dart';
import 'package:mobile_app/pages/course_page.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:hexagon/hexagon.dart';
import 'package:mobile_app/services/roadmap_service.dart';

class RoadmapPage extends StatelessWidget {

  final ModuleService moduleService = ModuleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future:moduleService.fetchModules(),
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
                    roadmap: RoadmapWidget(courses: module['courses'], evaluations: [module['evaluation']]),
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
  final List<dynamic> evaluations;

  RoadmapWidget({required this.courses, required this.evaluations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...courses.map((course) => Padding(
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
        )),
        SizedBox(height: 20),
        ...evaluations.map((evaluation) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Align(
              alignment: Alignment.center,
              child: EvaluationHexagon(
                title: evaluation['title'],
                evaluationId: evaluation['evaluationId'],
                summary: evaluation['summary'],
              ),
            ),
        ))
      ]
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
                  child: Text("Commencer"),
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

class EvaluationHexagon extends StatelessWidget {
  final String title;
  final int evaluationId;
  final String summary;

  EvaluationHexagon(
      {required this.title, required this.evaluationId, required this.summary});

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
              side: const BorderSide(color: Color.fromRGBO(255, 165, 0, 1)), // Orange border
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
                Text(summary, textAlign: TextAlign.center),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvaluationPage(evaluationId: evaluationId),
                      ),
                    );
                  },
                  child: Text("Regarder"),
                ),
              ],
            ),
          ),
        );
      },
      child: HexagonWidget.pointy(
        width: size,
        color: CustomColors.orangeAccent, // Change to your desired orange color
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