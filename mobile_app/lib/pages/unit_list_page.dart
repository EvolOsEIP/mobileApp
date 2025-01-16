import 'dart:convert';
import 'package:flutter/material.dart';

class UnitListPage extends StatefulWidget {
  const UnitListPage({super.key});

  @override
  _UnitListPageState createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  Future<void> getDatas() async {
    try {
      String dataString = await DefaultAssetBundle.of(context)
          .loadString('assets/chapters.json');

      setState(() {
        data = jsonDecode(dataString);
      });
    } catch (e) {
      print("Error loading the JSON file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des modules'),
      ),
      // hello world body
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data["units"][index]['name']),
                  onTap: () {
                    Navigator.pushNamed(context, '/chapters',
                        arguments: data["units"][index]);
                  },
                );
              },
            ),
    );
  }
}
