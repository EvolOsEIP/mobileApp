import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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