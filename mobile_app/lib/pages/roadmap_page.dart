import 'package:flutter/material.dart';
import 'package:mobile_app/pages/evaluation_page.dart';
import 'package:mobile_app/utils/navbar.dart';
import 'package:mobile_app/pages/course_page.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/hexagon_item.dart';
import 'package:mobile_app/services/roadmap_service.dart';

/// Enum to define the alignment of the hexagon items.
enum HexagonAlignment { left, center, right }

/// A stateless widget that represents the roadmap page.
///
/// The roadmap page displays a list of modules and their courses, as well as evaluations.
/// It fetches module data asynchronously from the `ModuleService`.
class RoadmapPage extends StatelessWidget {
  final ModuleService moduleService = ModuleService();

  RoadmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: moduleService.fetchModules(),
        builder: (context, snapshot) {
          // If the data is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If there is an error during the fetch
          else if (snapshot.hasError) {
            return const Center(child: Text('Error loading roadmap'));
          }
          // If no modules are available
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No modules available'));
          }
          // Display the roadmap content
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 20),
                // Mapping through each module and creating a roadmap section
                ...snapshot.data!.map((module) => RoadmapSection(module: module)),
              ],
            ),
          );
        },
      ),
      // Bottom navigation bar
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(10.0),
        child: CustomNavbar(
            profileImageUrl:
            "https://randomuser.me/api/portraits/women/44.jpg"),
      ),
    );
  }
}

/// A stateless widget representing a section of the roadmap.
///
/// It displays a module's name, a list of courses, and any associated evaluation.
class RoadmapSection extends StatelessWidget {
  final dynamic module;

  const RoadmapSection({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with the module name
        DividerWidget(title: module['modulename']),
        const SizedBox(height: 10),
        // Displays the courses and evaluation within the module
        RoadmapWidget(courses: module['courses'], evaluation: module['evaluation']),
        const SizedBox(height: 10)
      ],
    );
  }
}

/// A stateless widget that displays a divider with the module name.
///
/// This widget includes a title that is the module name, and adds dividers on both sides.
class DividerWidget extends StatelessWidget {
  final String title;

  const DividerWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1, color: CustomColors.primary)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.primary))),
        const Expanded(child: Divider(thickness: 1,color: CustomColors.primary)),
      ],
    );
  }
}

/// A stateless widget that displays a list of courses and an evaluation.
///
/// Each course is presented in a hexagonal format with a "Commencer" button. The evaluation is also displayed as a hexagon with a "Regarder" button.
class RoadmapWidget extends StatelessWidget {
  final List<dynamic> courses;
  final dynamic evaluation;

  const RoadmapWidget({super.key, required this.courses, required this.evaluation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
          children: [
            // Displaying each course in a hexagon item
            ...courses.map((course) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: _getMainAxisAlignment(
                  (course['courseIndex'] % 2 == 0) ? HexagonAlignment.left : HexagonAlignment.right,
                ),
                children: [
                  HexagonItem(
                    title: course['title'],
                    description: course['description'],
                    onTapAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CoursePage(courseId: course['courseId'])),
                    ),
                    hexColor: CustomColors.accent,
                    borderColor: const Color.fromRGBO(55, 190, 240, 1),
                    buttonText: "Commencer",
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            // Displaying the evaluation in a hexagon item
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: _getMainAxisAlignment(HexagonAlignment.center),
                children: [
                  HexagonItem(
                    title: evaluation['title'],
                    description: evaluation['summary'],
                    onTapAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EvaluationPage(evaluationId: evaluation['evaluationId'], score: evaluation['scorePercentage'],)),
                    ),
                    hexColor: CustomColors.orangeAccent,
                    borderColor: const Color.fromRGBO(255, 165, 0, 1),
                    buttonText: "Regarder",
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }

  /// Returns the alignment for the hexagon items based on the provided `alignment` value.
  ///
  /// This method decides whether the hexagon items should be aligned to the left, center, or right based on the alignment passed.
  MainAxisAlignment _getMainAxisAlignment(HexagonAlignment alignment) {
    switch (alignment) {
      case HexagonAlignment.left:
        return MainAxisAlignment.start;
      case HexagonAlignment.right:
        return MainAxisAlignment.end;
      case HexagonAlignment.center:
        return MainAxisAlignment.center;
    }
  }
}