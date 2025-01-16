import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_app/utils/colors.dart';

class ChapterListPage extends StatefulWidget {
  final dynamic units;
  const ChapterListPage({super.key, required this.units});

  @override
  _ChapterListPageState createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  @override
  Widget build(BuildContext context) {
    final units = ModalRoute.of(context)!.settings.arguments as dynamic;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Chapters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: units == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: units["chapters"].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/courses',
                        arguments: units["chapters"][index]);
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
                                    units["chapters"][index]['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  units["chapters"][index]['description'],
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
