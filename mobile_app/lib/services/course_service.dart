import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// Service class responsible for fetching information about course from an API
class CourseService {
  final String apiUrl = 'http://localhost:3000/api';

  /// Fetches the steps of a given course from the API.
  ///
  /// [courseId] - The ID of the course whose steps should be retrieved.
  /// Returns a list of step data if successful, otherwise throws an exception.
  Future<List<dynamic>> fetchSteps(int courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/courses/$courseId/steps'),
        headers: {
          'Authorization': '',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("ERROR : Failed to get steps: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error : $e");
    }
  }

  /// Loads course steps from a local JSON file.
  ///
  /// [filePath] - The path to the JSON file containing course steps.
  /// Returns a list of step data if successful, otherwise throws an exception.
  Future<List<dynamic>> fetchStepsFromJson(String filePath) async {
    try {
      print("try to get step from json");
      final String jsonString = await rootBundle.loadString(filePath);
      final List<dynamic> jsonData = jsonDecode(jsonString);
      print("JSON chargé : $jsonData");  // DEBUG
      return jsonData;
    } catch (e) {
      throw Exception("Failed to load local JSON: $e");
    }
  }
}
