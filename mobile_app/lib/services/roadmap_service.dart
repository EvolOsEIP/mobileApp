import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/loadJson.dart';

Future<List<dynamic>> fetchModules(header, context) async {
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
    return fetchFromJson('assets/json/offline_modules.json');
  }
}