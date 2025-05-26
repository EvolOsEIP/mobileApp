import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/fetchData.dart';

/// Service class responsible for fetching information about course from an API
class CourseService {
  /// Fetches the steps of a given course from the API.
  ///
  /// [courseId] - The ID of the course whose steps should be retrieved.
  /// Returns a list of step data if successful, otherwise throws an exception.
  Future<List<dynamic>> fetchSteps(int courseId) async {
    try {
      List<dynamic> step = await fetchFromApi(
          '/api/courses/$courseId/steps',
          headers: {'Authorization': dotenv.env['API_KEY'].toString()});
      if (step.isEmpty) {
        step = await fetchFromJson('assets/json/courses_pages.json');
      }
      return step;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching from API, loading local JSON: $e");
      }
      return fetchFromJson('assets/json/courses_pages.json');
    }
  }
}
