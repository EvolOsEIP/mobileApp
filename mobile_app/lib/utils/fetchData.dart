import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchFromJson(String filePath) async {
  try {
    final String jsonString = await rootBundle.loadString(filePath);
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData;
  } catch (e) {
    throw Exception("Failed to load local JSON: $e");
  }
}

Future<List<dynamic>> fetchFromApi(String endpoint, {Map<String, String>? headers}) async {
  var url = Uri.http(dotenv.env["HOST_URL"].toString(), endpoint);
  try {
    final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Widget buildLoadingIndicator(String textToDisplay) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(textToDisplay),
      ],
    ),
  );
}