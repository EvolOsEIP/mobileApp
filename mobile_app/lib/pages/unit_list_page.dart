import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/utils/colors.dart';

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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data["units"].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/chapters',
                        arguments: data["units"][index]);
                  },
                  child: Card(
                    color: CustomColors.accent,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: SizedBox(
                      height: 250, // Set the desired height for the cards
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(children: [
                          SvgPicture.asset(
                            "assets/images/genetic-data-svgrepo-com.svg",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    data["units"][index]['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  data["units"][index]["description"],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
