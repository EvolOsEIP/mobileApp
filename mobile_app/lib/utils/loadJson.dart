import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<dynamic>> fetchFromJson(String filePath) async {
  try {
    final String jsonString = await rootBundle.loadString(filePath);
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData;
  } catch (e) {
    throw Exception("Failed to load local JSON: $e");
  }
}