import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  final String apiUrl = 'http://localhost:3000/api';

  Future<List<dynamic>> fetchSteps(int courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/courses/$courseId/steps'),
        headers: {
          'Authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJlbWFpbCI6ImFkbWluQGV4YW1wbGUuY29tIiwicGFzc3dvcmRoYXNoIjoic2VjdXJlcGFzc3dvcmQxMjMiLCJjcmVhdGVkYXQiOiIyMDI1LTAzLTA1VDAzOjQ2OjI0LjYxM1oiLCJyb2xlIjoiYWRtaW4ifQ.DzAtI2oBHhOgFO1U14RCNmntnD90Z1do5XAlCEl44Jc', // Ajoute un token si besoin
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception("Erreur lors de la récupération des étapes : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur réseau : $e");
    }
  }
}
