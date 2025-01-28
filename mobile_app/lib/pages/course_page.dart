import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert'; // Provides JSON encoding and decoding utilities.
import 'package:http/http.dart' as http; // Library for making HTTP requests.
import 'typing_course_page.dart';
import '../utils/assistant.dart';
import 'multiplechoice_course_page.dart';

/// This part is used to load courses content.
///
/// This page display the different steps that composed a course load from a json file.
/// The user can enter his answer and we compare to the exception given in the json file.
///

enum CourseType { typing, multipleChoice, fillIn }

class CoursePage extends StatefulWidget {
  /// Courses load from the json file is load here.
  final dynamic courses;

  /// Creation of an instance 'CoursesPage'.
  const CoursePage({super.key, required this.courses});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  /// Dialogs used by the Assistant.
  dynamic dialogs;

  dynamic chapter;

  /// Data of the current course.
  dynamic course;

  /// ???
  dynamic args;

  /// Index for the dialogs of the assistant.
  int currentDialogIndex = 0;

  /// Index for the current Instruction
  int currentInstructionIndex = 0;

  /// ???
  String displayedText = "";

  /// Boolean to know if the assistant is writing or not.
  bool isTyping = false;

  /// ???
  bool isBlinking = false;

  /// ???
  Timer blinkTimer = Timer(Duration.zero, () {});

  dynamic units;

  CourseType courseType = CourseType.multipleChoice;

  dynamic jsondata = '''{
        "course_title": "General Knowledge Quiz",
        "questions": [
          {
            "question": "What is the capital of France?",
            "choices": ["Berlin", "Madrid", "Paris", "Rome"],
            "answer": "Paris"
          },
          {
            "question": "Which planet is known as the Red Planet?",
            "choices": ["Earth", "Mars", "Jupiter", "Venus"],
            "answer": "Mars"
          },
          {
            "question": "What is the largest mammal?",
            "choices": ["Elephant", "Blue Whale", "Giraffe", "Orca"],
            "answer": "Blue Whale"
          }
        ]
      }''';

  //create an enum to manage the different types of courses to display

  /// Controller to check the field input.
  final _inputController = TextEditingController();

  Future<void> _fetchUnits(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          units = jsonDecode(response.body);
        });
      } else {
        setState(() {
          units = null;
        });
        print('Failed to load chapters');
      }
    } catch (e) {
      print('Failed to load chapters');
      print(e);
    }
  }

  /// Initialize the widget.
  ///
  /// Add a listener to check the value of the input field.
  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      /// update the variable
      setState(() {});
    });
  }

  /// Clean the resources used by the widget.
  ///
  /// Delete the listener to avoid memory link
  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  /// Displays a pop-up when the course is completed.
  ///
  /// The pop-up shows a completion message from the course content and redirects to the courses list.
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cours complété"),
        content: Text(course["end"]),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/courses', arguments: chapter);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Chapters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //Choose the type of course to display
            if (courseType == CourseType.typing)
              TypingCoursePage(
                courses: course,
                // inputController: _inputController,
                // nextInstruction: _nextInstruction,
                // errorMessage: errorMessage,
              ),
            if (courseType == CourseType.multipleChoice)
              MultipleChoiceCourse(
                jsonData: jsondata,
                // inputController: _inputController,
                // nextInstruction: _nextInstruction,
                // errorMessage: errorMessage,
              )
            // Assistant widget, overlaid on top of the content
            // if (course['dialogs'] != null && course['dialogs'].isNotEmpty)
            // Positioned(
            // top: 0,
            // left: 0,
            // right: 0,
            // child: Assistant(
            // dialogs: course['dialogs'],
            // onComplete: () {
            // setState(() {
            // course['dialogs'] = [];
            // });
            // },
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
