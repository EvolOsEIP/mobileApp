import 'dart:convert'; // Provides JSON encoding and decoding utilities.
import 'package:flutter/material.dart'; // Flutter framework for UI components.
import 'package:http/http.dart' as http; // Library for making HTTP requests.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Library to read configuration from a .env file.

Future<void> _fetchUnits() async {
  try {
    final response = await http.get(
      Uri.parse(dotenv.env['API_URL'].toString() + '/chapters'),
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
