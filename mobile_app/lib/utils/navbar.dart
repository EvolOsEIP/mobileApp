import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/utils/fixPseudoJson.dart';
import 'package:mobile_app/utils/loadProfileImage.dart';
class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  String profileImageUrl = "default.png";

  @override
  void initState() {
    super.initState();
    _loadProfile(); // appel initial
  }

  void _loadProfile() async {
    String url = await loadProfileImage(context);
    setState(() {
      profileImageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double navbarHeight = screenWidth * 0.10;
    double iconSize = screenWidth * 0.07;
    double avatarSize = screenWidth * 0.07;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(navbarHeight * 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != '/profile') {
                Navigator.pushNamed(context, '/profile');
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize * 0.5),
              child: Image.network(
                "http://" +
                    dotenv.env["HOST_URL"].toString() +
                    "/api/images/" +
                    profileImageUrl,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.menu_book,
                color: CustomColors.dark_accent, size: iconSize),
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/roadmap') {
                Navigator.pushNamed(context, '/roadmap');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.star_border,
                color: CustomColors.dark_accent, size: iconSize),
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/success') {
                Navigator.pushNamed(context, '/success');
              }
            },
          ),
        ],
      ),
    );
  }
}
