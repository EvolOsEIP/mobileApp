import 'dart:convert';
import 'package:flutter/material.dart';

class Quiz {
  final String courseTitle;
  final List<Question> questions;

  Quiz({required this.courseTitle, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      courseTitle: json['course_title'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }
}

class Question {
  final String question;
  final List<String> choices;
  final String answer;

  Question(
      {required this.question, required this.choices, required this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      choices: List<String>.from(json['choices']),
      answer: json['answer'],
    );
  }
}

class MultipleChoiceCourse extends StatefulWidget {
  final String jsonData; // Pass the JSON data as a string

  const MultipleChoiceCourse({Key? key, required this.jsonData})
      : super(key: key);

  @override
  _MultipleChoiceCourseState createState() => _MultipleChoiceCourseState();
}

class _MultipleChoiceCourseState extends State<MultipleChoiceCourse> {
  late Quiz quiz;
  int currentQuestionIndex = 0;
  String selectedChoice = "";
  String feedback = "";

  @override
  void initState() {
    super.initState();
    final decodedJson = json.decode(widget.jsonData);
    quiz = Quiz.fromJson(decodedJson);
  }

  void _checkAnswer() {
    if (selectedChoice == quiz.questions[currentQuestionIndex].answer) {
      setState(() {
        feedback = "Correct!";
      });
    } else {
      setState(() {
        feedback = "Wrong answer. Try again!";
      });
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedChoice = "";
        feedback = "";
      });
    } else {
      setState(() {
        feedback = "Quiz Completed!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = quiz.questions[currentQuestionIndex];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(quiz.courseTitle),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1} of ${quiz.questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Column(
              children: question.choices.map((choice) {
                return RadioListTile(
                  title: Text(choice),
                  value: choice,
                  groupValue: selectedChoice,
                  onChanged: (value) {
                    setState(() {
                      selectedChoice = value!;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (feedback.isNotEmpty)
              Text(
                feedback,
                style: TextStyle(
                  color: feedback == "Correct!" ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: selectedChoice.isNotEmpty ? _checkAnswer : null,
                  child: const Text("Check Answer"),
                ),
                ElevatedButton(
                  onPressed:
                      feedback == "Correct!" || feedback == "Quiz Completed!"
                          ? _nextQuestion
                          : null,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
