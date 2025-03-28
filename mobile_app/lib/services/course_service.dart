import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class responsible for fetching information about course from an API
class CourseService {
  /// Fetches the steps of a given course from the API.
  ///
  /// [courseId] - The ID of the course whose steps should be retrieved.
  /// Returns a list of step data if successful, otherwise throws an exception.
  Future<List<dynamic>> fetchSteps(int courseId) async {
    var url = Uri.http(
        dotenv.env["HOST_URL"].toString(), '/api/courses/$courseId/steps');
    try {
      final response = await http.get(url,
          headers: {'Authorization': dotenv.env['API_KEY'].toString()});
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
}
